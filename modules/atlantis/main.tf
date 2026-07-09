locals {
  service_account_name = "atlantis"
  oidc_provider_host   = replace(var.oidc_provider_url, "https://", "")
}

data "aws_iam_policy_document" "atlantis_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_host}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${local.service_account_name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_host}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "atlantis" {
  name               = "${var.cluster_name}-atlantis"
  assume_role_policy = data.aws_iam_policy_document.atlantis_assume_role.json
  tags               = merge(var.tags, { Name = "${var.cluster_name}-atlantis" })
}

resource "aws_iam_role_policy_attachment" "atlantis" {
  for_each   = toset(var.iam_policy_arns)
  role       = aws_iam_role.atlantis.name
  policy_arn = each.value
}


locals {
  repo_config = <<-EOT
    repos:
      - id: /.*/
        allowed_workflows: [terragrunt]
        allow_custom_workflows: false

    workflows:
      terragrunt:
        plan:
          steps:
            - run: terragrunt init -no-color
            - run: terragrunt plan -no-color -out $PLANFILE
        apply:
          steps:
            - run: terragrunt apply -no-color $PLANFILE
  EOT
}

resource "helm_release" "atlantis" {
  name             = "atlantis"
  repository       = "https://runatlantis.github.io/helm-charts"
  chart            = "atlantis"
  version          = var.atlantis_chart_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      image = {
        repository = var.atlantis_image_repository
        tag        = var.atlantis_image_tag
      }

      github = {
        user   = var.vcs_provider_user
        token  = var.vcs_provider_token
        secret = var.vcs_webhook_secret
      }

      orgAllowlist = var.repo_allowlist
      atlantisUrl  = var.atlantis_url
      repoConfig   = local.repo_config

      service = {
        type        = var.service_type
        annotations = var.service_annotations
      }

      serviceAccount = {
        create = true
        name   = local.service_account_name
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.atlantis.arn
        }
      }

      resources = var.resources

      volumeClaim = {
        enabled          = true
        dataStorage      = "5Gi"
        storageClassName = "gp2"
        accessModes      = ["ReadWriteOnce"]
      }

      initContainers = [
        {
          name  = "install-terragrunt"
          image = "curlimages/curl:8.10.1"
          command = [
            "sh", "-c",
            "curl -sSL -o /extra-bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${var.terragrunt_version}/terragrunt_linux_amd64 && chmod +x /extra-bin/terragrunt"
          ]
          volumeMounts = [
            {
              name      = "terragrunt-bin"
              mountPath = "/extra-bin"
            }
          ]
        }
      ]

      extraVolumes = [
        {
          name     = "terragrunt-bin"
          emptyDir = {}
        }
      ]

      extraVolumeMounts = [
        {
          name      = "terragrunt-bin"
          mountPath = "/usr/local/bin/terragrunt"
          subPath   = "terragrunt"
          readOnly  = true
        }
      ]
    })
  ]

  depends_on = [aws_iam_role_policy_attachment.atlantis]
}
