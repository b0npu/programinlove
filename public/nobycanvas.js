document.addEventListener('DOMContentLoaded', function(){
  /* 配列の要素番号 */
  var index = 0;
  /* キャラクターの情緒状態を確認 */
  var talking = document.getElementById("nobycanvas").dataset.nobystate;

  /* 通常時の画像 */
  var normalImg = ["img/normal/0000.png"];
  /* 瞬きのアニメーション用の画像 */
  var blinkImg = [
    "img/normal/0000.png",
    "img/blink/0000.png",
    "img/blink/0001.png",
    "img/normal/0000.png"
  ];
  /* 見回すアニメーション用の画像 */
  var lookImg = [
    "img/normal/0000.png",
    "img/lookaround/0000.png",
    "img/lookaround/0001.png",
    "img/lookaround/0002.png",
    "img/lookaround/0003.png",
    "img/lookaround/0004.png",
    "img/normal/0000.png"
  ];
  /* 喋るアニメーション用の画像 */
  var talkImg = [
    "img/normal/0000.png",
    "img/talk/0000.png",
    "img/talk/0001.png",
    "img/talk/0000.png",
    "img/talk/0001.png",
    "img/normal/0000.png"
  ];

  /* 関数の中で画像を操作するための配列 */
  var animePtn = [normalImg, blinkImg, lookImg];
  var imgAry = [];

  /* ３種類のアニメーションからランダムに選択 */
  function selectAnime() {
    imgAry = animePtn[Math.floor(Math.random() * 3)];
  }

  /* 画像を順番に表示してアニメーションを作成 */
  function flipAnime(){
    document.getElementById("nobycanvas").getElementsByTagName("img")[0].src = imgAry[index];
    index++;
    if (index >= imgAry.length){
      index = 0;
      clerTimeout(timeoutId);
    }
    timeoutId = setTimeout(flipAnime, 100);
  }

  /* 応答時は喋るアニメーションを表示 */
  if (talking) {
    imgAry = talkImg;
    talking = '';
    flipAnime();
  }

  /* 待機時は適当なアニメーションを選んで表示する */
  setInterval(selectAnime, 5000);
  setInterval(flipAnime, 5000);
});
