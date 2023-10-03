

#!/bin/bash



# set the Cassandra version to upgrade to

CASSANDRA_VERSION=${LATEST_VERSION}



# loop through all nodes in the cluster

for node in ${NODE1_NODE2_NODE3}

do

    # check if the node is already running the latest version

    if nodetool -h $node version | grep -q $CASSANDRA_VERSION

    then

        echo "Node $node is already running the latest version of Cassandra"

    else

        # stop Cassandra service on the node

        ssh $node sudo service cassandra stop

        # download and install the latest version of Cassandra on the node

        ssh $node wget ${LINK_TO_LATEST_CASSANDRA_VERSION}

        ssh $node tar zxf ${CASSANDRA_TARBALL_NAME}.tar.gz

        ssh $node sudo mkdir -p /opt/cassandra

        ssh $node sudo mv ${CASSANDRA_TARBALL_NAME} /opt/cassandra

        # update the symbolic link to point to the new version of Cassandra

        ssh $node sudo ln -sfn /opt/cassandra/${CASSANDRA_VERSION} /opt/cassandra/current

        # start Cassandra service on the node

        ssh $node sudo service cassandra start

        echo "Upgraded Cassandra version on node $node to $CASSANDRA_VERSION"

    fi

done