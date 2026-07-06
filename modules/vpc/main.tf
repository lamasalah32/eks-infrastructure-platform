resource "aws_vpc" "this" {
  cidr_block  = var.cidr

  tags = merge(
    {
      Name = "my-vpc"
    },
    var.tags,
  )
}


/*  Internet gateway  */
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

/*  NAT gateway  */
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    {
      Name = "nat-eip"
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    {
      Name = "nat-gateway"
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.igw]
}


/*  Public subnets   */
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  count                   = var.public_subnets == null ? 0 : length(var.public_subnets)
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "public" {
  count           = aws_route_table.public == null ? 0 : length(aws_subnet.public)
  subnet_id       = aws_subnet.public[count.index].id
  route_table_id  = aws_route_table.public.id
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"

   timeouts {
    create = "5m"
  }
}


/*  Private subnets   */
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.this.id
  count                   = var.private_subnets == null ? 0 : length(var.private_subnets)
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.azs[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "private" {
  count           = aws_route_table.private == null ? 0 : length(aws_subnet.private)
  subnet_id       = aws_subnet.private[count.index].id
  route_table_id  = aws_route_table.private.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"

  timeouts {
    create = "5m"
  }
}
