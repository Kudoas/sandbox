[
  ["Herb の Fragment", "検索欄に Herb と入力して、Fallback の表示を試してみましょう。"],
  ["Rails で CRUD", "作成・表示・編集・削除は普通の Rails フォームで行います。"],
  ["SQLite のメモ", "データベースの用意は不要。ローカルのファイルに保存します。"],
  ["週末の買い物", "コーヒー、パン、牛乳。"],
  ["読書メモ", "気になった文章をここに記録します。"]
].each do |title, body|
  Note.find_or_create_by!(title: title) { |note| note.body = body }
end
