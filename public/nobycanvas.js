document.addEventListener('DOMContentLoaded', function(){
  /* 配列の要素番号 */
  var index = 0;
  /* キャラクターの情緒状態を確認 */
  var nobyState = document.getElementById("nobycanvas").dataset.nobystate;

  /* 喋る画像を情緒ごとに格納 */
  var talkPtn = {
    talk: [
      "img/normal/0000.png",
      "img/talk/0000.png",
      "img/talk/0001.png",
      "img/talk/0000.png",
      "img/talk/0001.png",
      "img/normal/0000.png"
    ],
    happy_talk: [
      "img/happy/0000.png",
      "img/happy_talk/0000.png",
      "img/happy_talk/0001.png",
      "img/happy_talk/0000.png",
      "img/happy_talk/0001.png",
      "img/happy/0000.png"
    ],
    more_happy_talk: [
      "img/more_happy/0000.png",
      "img/more_happy_talk/0000.png",
      "img/more_happy_talk/0001.png",
      "img/more_happy_talk/0002.png",
      "img/more_happy_talk/0000.png",
      "img/more_happy_talk/0001.png",
      "img/more_happy_talk/0002.png",
      "img/more_happy/0000.png"
    ],
    angry_talk: [
      "img/angry/0000.png",
      "img/angry_talk/0000.png",
      "img/angry_talk/0001.png",
      "img/angry_talk/0000.png",
      "img/angry_talk/0001.png",
      "img/angry/0000.png"
    ],
    more_angry_talk: [
      "img/more_angry/0000.png",
      "img/more_angry_talk/0000.png",
      "img/more_angry_talk/0001.png",
      "img/more_angry_talk/0000.png",
      "img/more_angry_talk/0001.png",
      "img/more_angry/0000.png"
    ]
  };

  /* 情緒ごとのアニメーションのパターンを作成 */
  /* 通常時のパターン */
  var normalPtn = [
    ["img/normal/0000.png"],
    [
      "img/normal/0000.png",
      "img/blink/0000.png",
      "img/blink/0001.png",
      "img/normal/0000.png"
    ],
    [
      "img/normal/0000.png",
      "img/lookaround/0000.png",
      "img/lookaround/0001.png",
      "img/lookaround/0002.png",
      "img/lookaround/0003.png",
      "img/lookaround/0004.png",
      "img/normal/0000.png"
    ]
  ];
  /* 機嫌がいい時のパターン */
  var happyPtn = [
    ["img/happy/0000.png"],
    [
      "img/happy/0000.png",
      "img/happy_blink/0000.png",
      "img/happy_blink/0001.png",
      "img/happy/0000.png"
    ]
  ];
  /* 上機嫌の時のパターン */
  var moreHappyPtn = [
    ["img/more_happy/0000.png"],
    [
      "img/more_happy/0000.png",
      "img/more_happy_blink/0000.png",
      "img/more_happy_blink/0001.png",
      "img/more_happy/0000.png"
    ]
  ];
  /* 機嫌が悪い時のパターン */
  var angryPtn = [
    ["img/angry/0000.png"],
  ];
  /* 怒っている時のパターン */
  var moreAngryPtn = [
    ["img/more_angry/0000.png"],
  ];

  /* 関数の中で画像を操作するための変数 */
  var animePtn = [];
  var imgAry = [];
  var timeoutId;

  /* 応答時のアニメーションを表示 */
  function respAnime(looks) {
    imgAry = talkPtn[looks];
    nobyState = '';
    flipAnime();
  }

  /* アニメーションのパターンからランダムに選択 */
  function selectAnime() {
    imgAry = animePtn[Math.floor(Math.random() * animePtn.length)];
  }

  /* 画像を順番に表示してアニメーションを作成 */
  function flipAnime(){
    timeoutId = setTimeout(flipAnime, 100);

    document.getElementById("nobycanvas").getElementsByTagName("img")[0].src = imgAry[index];
    index++;
    if (index >= imgAry.length){
      index = 0;
      clearTimeout(timeoutId);
    }
  }

  /* 情緒状態によって表情を変化させる */
  /* 応答時は喋るアニメーションを表示 */
  switch (nobyState) {
    case 'talk':
      respAnime('talk');
      animePtn = normalPtn;
      break;
    case 'happy_talk':
      respAnime('happy_talk');
      animePtn = happyPtn;
      break;
    case 'more_happy_talk':
      respAnime('more_happy_talk');
      animePtn = moreHappyPtn;
      break;
    case 'angry_talk':
      respAnime('angry_talk');
      animePtn = angryPtn;
      break;
    case 'more_angry_talk':
      respAnime('more_angry_talk');
      animePtn = moreAngryPtn;
      break;
    default:
      animePtn = normalPtn;
      break;
  }

  /* 待機時は適当なアニメーションを選んで表示する */
  setInterval(selectAnime, 5000);
  setInterval(flipAnime, 5000);
});
