output=`aws ecs describe-services --cluster $1 --services $2 | jq ".services[0].networkConfiguration"`

subnets=`echo $output | jq -r '.awsvpcConfiguration.subnets|join(",")'`
echo $subnets
securityGroups=`echo $output | jq -r '.awsvpcConfiguration.securityGroups|join(",")'`
echo $securityGroups
assignPublicIp=`echo $output | jq -r '.awsvpcConfiguration.assignPublicIp'`

sed "s/\${app_name}/$4/g" run_task_db_migrate_template.json > run_task_db_migrate__2.json

aws ecs run-task \
  --cluster $1 \
  --task-definition $3 \
  --launch-type 'EC2' \
  --overrides file://run_task_db_migrate.json