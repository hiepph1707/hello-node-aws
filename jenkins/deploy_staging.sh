TASK_DEFINITION=$(aws ecs describe-task-definition --task-definition "${STAGING_TASK}")

NEW_TASK_DEFINITION=$(echo $TASK_DEFINITION | jq --arg ECR_REPO "${ECR_REPO}:${APP_VERSION}" --arg APP_VERSION "${APP_VERSION}" --arg APP_ENV "${APP_ENV}" '.taskDefinition |.containerDefinitions[0].image = $ECR_REPO | .containerDefinitions[0].environment[0].value = $APP_VERSION |.containerDefinitions[0].environment[1].value = $APP_ENV  | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities) | del(.registeredAt) | del(."registeredBy")')

TASK_VERSION=$(aws ecs register-task-definition --cli-input-json "$NEW_TASK_DEFINITION" | jq --raw-output '.taskDefinition.revision')
ECS_UPDATE=$(aws ecs update-service --force-new-deployment --cluster ${STAGING_CLUSTER}  --service ${STAGING_SERVICE} --task-definition ${STAGING_TASK}:$TASK_VERSION  | jq --raw-output '.service.serviceName')

