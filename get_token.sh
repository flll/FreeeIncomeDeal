#!/bin/sh -e

#変数読み込み
source ./app.env

#リフレッシュトークンの取得
refresh_token=$(
    cat refresh_token.env
)

#Freeから認証情報を取得する
refresh_token_json=$(
    curl -X POST \
        -H "Content-Type:application/x-www-form-urlencoded" \
        -d "grant_type=refresh_token" \
        -d "client_id=${client_id}" \
        -d "client_secret=${client_secret}" \
        -d "refresh_token=${refresh_token}" \
        -d "redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob" \
        'https://accounts.secure.freee.co.jp/public_api/token'
)
#アクセストークンを抜粋
access_token=$( 
    echo $refresh_token_json \
        | jq -r .access_token
)
#リフレッシュトークンの抜粋 & 保存
refresh_token=$(
    echo $refresh_token_json \
        | jq -r .refresh_token \
        | tee refresh_token.env
)

echo トークン読み込み完了 && return 0

CODE再取得するときに使うやつ
curl -i -X POST \
 -H "Content-Type:application/x-www-form-urlencoded" \
 -d "grant_type=authorization_code" \
 -d "client_id=${client_id}" \
 -d "client_secret=${client_secret}" \
 -d "code=#App管理WEBサイトからトークンを置き換える#" \
 -d "redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob" \
 'https://accounts.secure.freee.co.jp/public_api/token'

