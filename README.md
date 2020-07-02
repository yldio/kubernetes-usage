# kubernetes-usage
Reporting tool for Kubernetes usage

# Run 
```
chmod +x usage.sh
./usage.sh > report-`kubectl config current-context`-`date +%d-%m-%Y-%H:%M:%S`.csv
```
