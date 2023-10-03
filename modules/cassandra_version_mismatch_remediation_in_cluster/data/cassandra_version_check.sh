

#!/bin/bash



# Define variables


nodes=${NODE1_NODE2_NODE3}  # Replace with the nodes you want to check



# Loop through nodes and check Cassandra version

for node in ${NODE1_NODE2_NODE3}

do

  version=$(ssh $node "cassandra -v | awk '{ print \$NF }'")  # Get Cassandra version on node

  if [[ $version == $cassandra_version ]]

  then

    echo "Node $node is running the correct version of Cassandra."

  else

    echo "Node $node is running a different version of Cassandra."

  fi

done