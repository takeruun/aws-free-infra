# AWS 無料範囲のインフラ構成コード

## 使用方法

### 初めに

#### state 管理用 S3 と 同時更新のブロックする Dynamodb 作成
1. AWS profile 設定
terraform 実行できるように AWS profile を設定する
```sh
export AWS_PROFILE=profile
```
2. S3 と Dynamodb 作成
```sh
cd backend

terraform init

terraform plan

terraform apply
```

#### リソース作成
##### 作成順番
network → alb → s3_images → rds → spa → ecs_api
各々のディレクトリに移動して、以下の手順を実行する

1. AWS profile 設定
terraform 実行できるように AWS profile を設定する
```sh
export AWS_PROFILE=profile
```

2. 初期化
`-backend-config=../env/backend.config` を指定して、s3 にある stateファイル と Dynamodb を更新する
```sh
terraform init -backend-config=../env/backend.config
```

3. プラン
`-var-file` を指定して、変数を読み込む
```sh
terraform plan -var-file=../env/vars/example.tfvars
```

4. デプロイ
`-var-file` を指定して、変数を読み込む
```sh
terraform apply -var-file=../env/vars/example.tfvars
```

## ssh 接続
Session Manager ec2 に接続する
```sh
ssh -i ecs_api/ssh/aws-free-infra.pem ec2-user@$ec2-id
```

### コンテナに接続
```sh
sh ecs_api/ssm_agent/ssm.sh aws-free-infra-cluster aws-free-infra_api
```

### マイグレーション実行
マイグレーションコマンド実行するコンテナの作成
```sh
sh ecs_api/db_migrate/migrate.sh aws-free-infra-cluster aws-free-infra-service aws-free-infra_task aws-free-infra
```