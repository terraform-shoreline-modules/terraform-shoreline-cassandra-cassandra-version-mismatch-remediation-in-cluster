resource "shoreline_notebook" "cassandra_version_mismatch_remediation_in_cluster" {
  name       = "cassandra_version_mismatch_remediation_in_cluster"
  data       = file("${path.module}/data/cassandra_version_mismatch_remediation_in_cluster.json")
  depends_on = [shoreline_action.invoke_cassandra_version_check,shoreline_action.invoke_cassandra_upgrade]
}

resource "shoreline_file" "cassandra_version_check" {
  name             = "cassandra_version_check"
  input_file       = "${path.module}/data/cassandra_version_check.sh"
  md5              = filemd5("${path.module}/data/cassandra_version_check.sh")
  description      = "A new version of Cassandra was installed on a few nodes, but not all of them, resulting in a version mismatch."
  destination_path = "/agent/scripts/cassandra_version_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cassandra_upgrade" {
  name             = "cassandra_upgrade"
  input_file       = "${path.module}/data/cassandra_upgrade.sh"
  md5              = filemd5("${path.module}/data/cassandra_upgrade.sh")
  description      = "Upgrade all nodes to the latest version of Cassandra, ensuring that the upgrade process is completed successfully."
  destination_path = "/agent/scripts/cassandra_upgrade.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cassandra_version_check" {
  name        = "invoke_cassandra_version_check"
  description = "A new version of Cassandra was installed on a few nodes, but not all of them, resulting in a version mismatch."
  command     = "`chmod +x /agent/scripts/cassandra_version_check.sh && /agent/scripts/cassandra_version_check.sh`"
  params      = ["NODE1_NODE2_NODE3"]
  file_deps   = ["cassandra_version_check"]
  enabled     = true
  depends_on  = [shoreline_file.cassandra_version_check]
}

resource "shoreline_action" "invoke_cassandra_upgrade" {
  name        = "invoke_cassandra_upgrade"
  description = "Upgrade all nodes to the latest version of Cassandra, ensuring that the upgrade process is completed successfully."
  command     = "`chmod +x /agent/scripts/cassandra_upgrade.sh && /agent/scripts/cassandra_upgrade.sh`"
  params      = ["NODE1_NODE2_NODE3","LATEST_VERSION","CASSANDRA_VERSION","LINK_TO_LATEST_CASSANDRA_VERSION","CASSANDRA_TARBALL_NAME"]
  file_deps   = ["cassandra_upgrade"]
  enabled     = true
  depends_on  = [shoreline_file.cassandra_upgrade]
}

