provider "azurerm" {
  features {}
}
resource "azurerm_policy_definition" "policy" {
  name         = "${var.policyname}"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Custom ${var.policyname} Policy"

  metadata = <<METADATA
    {
    "category": "Tags",
    "version" : "1.0.1"
    }
METADATA

  policy_rule = <<POLICY_RULE
    {
      "if": {
        "anyOf": [
          {
          "field": "[concat('tags[', parameters('tagName1'), ']')]",
          "exists": "false"
          },
          {
          "field": "[concat('tags[', parameters('tagName2'), ']')]",
          "exists": "false"
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }
POLICY_RULE


  parameters = <<PARAMETERS
    {
      "tagName1": {
        "type": "String",
        "metadata": {
          "displayName": "First Tag Name for Resource",
          "description": "Name of the tag, such as 'environment'"
        }
      },
      "tagName2": {
        "type": "String",
        "metadata": {
          "displayName": "Second Tag Name for Resource",
          "description": "Name of the tag, such as 'project'"
        }
      }
    }
PARAMETERS

}