### runPsqlQuery
Execute a psql query via kubectl exec command

#### Usage
Make bash script executable by 
```sh
chmod +x pgs.sh
```

#### How to execute
```sh
./pgs.sh -n <namespace> -d <deployment name> -c <container name> -db <Database name>
```

- Arguments are optional, if not specified default valued specified in the `pgs.sh` will be taken.
- Make sure defaults values are correct.

#### Providing query
```sh
kubectl exec ${PGS_POD} -c ${CONTAINER} -n ${NAMESPACE} -- psql -d ${PGS_DB} -c 'update howdy set n=300' -c 'create table new01(n int)' 2>&1
```
- Here query is followed by `-c` option (make sure to escape if there is any special characters in your query)
- Multiple query can be used in the same line followed by `-c` option
