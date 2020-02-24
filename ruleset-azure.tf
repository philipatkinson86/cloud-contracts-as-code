##########################################
############ Add Ruleset  ################
##########################################
resource "dome9_ruleset" "dome9_azure_ruleset" {
  count       = var.azure_cloud_account_id == "" ? 1 : 0
  name        = "var.organization} - var.contract_name - Azure Ruleset"
  description = "Built and maintained with Terraform"
  cloud_vendor = "Azure"
  language = "en"
  hide_in_compliance = false
  is_template = false
  rules {
    # Storage Buckets with data classification 'secret' must always be encrypted
    name = "Storage Buckets with data classification 'secret' must always be encrypted"
    logic = "StorageAccount where tags contain [ key='data-classification' and value='secret' ] should have encryption.services with [ name='file' and enabled=true ]"
    severity = "Low"
    description = "StorageAccount with data classification 'secret' should have encryption.services with [ name='file' and enabled=true ]"
  }
}

##########################################
######### Add Compliance Policy ##########
##########################################

resource "dome9_continuous_compliance_policy" "dome9_azure_compliance_policy" {
  count               = var.azure_cloud_account_id == "" ? 1 : 0
  cloud_account_id    = "var.azure_cloud_account_id"
  external_account_id = "var.azure_account_subscription"
  bundle_id           = dome9_ruleset.dome9_azure_ruleset[count.index]
  cloud_account_type  = "Azure"
  notification_ids    = ["${dome9_continuous_compliance_notification.dome9_compliance_mail_notification.id}"]
}