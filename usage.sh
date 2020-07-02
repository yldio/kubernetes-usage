#!/usr/bin/env bash

echo "In use,owner,deployment name,namespace,number of replicas,min memory(per pod),min cpu(per pod),max memory(per pod),max cpu(per pod),last update, cpu usage(deployment),memory usage(deployment)"

for namespace in $(kubectl get namespace -o=jsonpath='{.items[*].metadata.name}')
do
  for deploy in $(kubectl get deployments -n $namespace -o=jsonpath='{.items[*].metadata.name}')
  do
      kubectl get deploy $deploy -n $namespace -o=jsonpath="{',,'}{.metadata.name}{','}{.metadata.namespace}{','}{.status.availableReplicas}{','}{.spec.template.spec.containers[?(@.name=='app')].resources['requests'].memory}{','}{.spec.template.spec.containers[?(@.name=='app')].resources['requests'].cpu}{','}{.spec.template.spec.containers[?(@.name=='app')].resources['limits'].memory}{','}{.spec.template.spec.containers[?(@.name=='app')].resources['limits'].cpu}{','}{.status.conditions[0].lastUpdateTime}"

      REPLICAS=$(kubectl get deployment $deploy -n $namespace -o=jsonpath="{.status.availableReplicas}")

      if [ ! -z $REPLICAS ]; then
        kubectl top pods -l release=$deploy -n $namespace --no-headers | awk '{print $2 $3}' | sed "s/[a-zA-Z]/ /" | sed "s/[a-zA-Z].*//" | awk '{cpu+=$1;memory+=$2} END {print ","cpu"m,"memory"Mi"}'
      else
        echo ",0m,0Mi"
      fi
  done
done
