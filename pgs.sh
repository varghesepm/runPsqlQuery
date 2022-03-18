#!/bin/bash
# set -x

# default values
NAMESPACE="default"
DEPLOYMENT="postgres"
CONTAINER="postgres"
PGS_DB="postgresdb"

USAGE(){
	echo "Usage: $0 -n [namespace name | Optional | default=${NAMESPACE}] -d [deployment name| Optional | default=${DEPLOYMENT}] -c [container name| Optional | default=${CONTAINER}] -db [Database name| Optional | default=${PGS_DB}]"
	exit 1
}

while getopts n:d:c:db: flag
do
	case "${flag}" in
		n) NAMESPACE=${OPTARG};;
		d) DEPLOYMENT=${OPTARG};;
		c) CONTAINER=${OPTARG};;
		db) PGS_DB=${OPTARG};; 
		h|*) USAGE ;;
	esac
done

# identifying podname from deployment label specified in the pod spec
PGS_POD=$(kubectl get pods -l app=${DEPLOYMENT} -n ${NAMESPACE} --no-headers -o custom-columns=":metadata.name" | head -n 1)

echo "Namespace: ${NAMESPACE}"
echo "Pod Name: ${PGS_POD}"
echo "Container: ${CONTAINER}"
echo "Database: ${PGS_DB}" 

query="select * from howdy where n='300'"

if [ ! -z ${PGS_POD} ]; then
	res=$(kubectl exec ${PGS_POD} -c ${CONTAINER} -n ${NAMESPACE} -- psql -U 'postgresadmin' -d ${PGS_DB} -c "${query}" 2>&1)
	echo $res
else
	echo "pod name is empty, please check provided arguments are correct!!"
	exit 1
fi