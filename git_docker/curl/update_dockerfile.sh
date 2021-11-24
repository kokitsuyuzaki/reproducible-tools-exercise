# Dockerイメージを更新
docker build -t koki/reductdims_curl .

# DockerHubに最新版をプッシュ
docker login -u koki
img=`docker images | grep koki/reductdims_curl | awk '{print $3}'`
docker tag $img koki/reductdims_curl:$(date '+%Y%m%d')
docker push koki/reductdims_curl:$(date '+%Y%m%d')

# 中に入って動作確認する時用
# docker run -it --rm koki/reductdims_curl:$(date '+%Y%m%d') bash