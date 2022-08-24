軽量かつ利便性の高い Dockerfile のサンプルを示すリポジトリ

簡単な Django アプリケーションを動作させる

# dev

ユニットテストを実行する

```shell
$ docker build --target dev -t hello-django:dev .
$ docker run -ti --rm hello-django:dev pytest .
```

# prod

サーバーを起動して curl でレスポンスを確認する

```shell
$ docker build --target prod -t hello-django:prod .
$ docker run -d --name hello-django -p 8000:8000 --rm hello-django:prod
$ curl localhost:8000/hello/
{"msg": "hello"}
```

prod 用イメージには pytest がインストールされていないことを確認する

```shell
$ docker run -it --rm hello-django:prod pytest .
docker: Error response from daemon: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: exec: "pytest": executable file not found in $PATH: unknown.
```
