output=`aws ecs list-tasks --cluster $1 | jq ".taskArns[0]"`
task=`echo $output | jq -r`

echo $task

aws ecs execute-command \
--cluster $1 \
--container $2 \
--task $task \
--command "ash" \
--interactive 