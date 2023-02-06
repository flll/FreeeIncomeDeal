#!/bin/sh -e

#変数読み込み
source ./app.env
#トークン取得処理
. ./get_token.sh

#入力処理 日と金額のみ
echo 日付を入力してください
echo 例 07
read day

echo 金額を入力してください
echo 例 99999
read amount

echo "${year}年${month}月${day}日 ${amount}円でFreeeに登録します"
echo "送信するにはEnterしてください"
read
#発生日データ入力
issue_date="${year}-${month}-${day}"

#取引収入用JSONファイル
deals_json=$(
    cat << EOF | jq -c
    {
        "issue_date": "${issue_date}",
        "type": "income",
        "company_id": ${company_id},
        "details": [
            {
                "tax_code": ${tax_code},
                "account_item_id": ${account_item_id},
                "amount": ${amount},
                "item_id": ${item_id},
                "tag_ids": [
                    ${tag_ids}
              ]
            }
        ],
        "payments": [
            {
            "amount": ${amount},
            "from_walletable_id": ${from_walletable_id},
            "from_walletable_type": "${from_walletable_type}",
            "date": "${issue_date}"
            }
        ]
    }
EOF
)

curl -X POST "https://api.freee.co.jp/api/1/deals" \
    -H "accept: application/json" \
    -H "Authorization: Bearer ${access_token}" \
    -H "Content-Type: application/json" \
    -H "X-Api-Version: 2020-06-15" \
    -d "${deals_json}"
