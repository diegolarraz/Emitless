

// const newSentence = (sentence) => {
//   document.querySelector(".sentence").fadeOut(300, function() {
//     $(this).html(sentence).fadeIn(500);
//   });
// }

export const submit_spinner = () => {
  const btn = document.getElementById('compare-btn');
  if (btn) {
    btn.addEventListener('click', (event) => {
      event.preventDefault();
      console.log("Prevented!");
      let body = document.querySelector("body")
      body.style.overflow = "hidden";
      body.insertAdjacentHTML("beforebegin", `<div class="background-holder"><div class="central-box"><div class="spin"><div class="loader"></div></br><h3 class="sentence">Finding clean products</h3></div></div></div>`);
      // document.querySelector('.background-holder').style.marginTop = window.pageYOffset;
      setInterval(newSentence, 1000);
      setTimeout(function(){ window.location.href = "/compare"; }, 3400);
    });
  }
};



let texts = ["Planting trees", "Turning plastic into quinoa", "Saving the planet"]
let index = 0;

export const newSentence = () => {
  document.querySelector(".sentence").innerHTML = texts[index];
  index < 3 ? index++ : index = 0;
};

// setInterval(newSentence("Planting trees", 800);
// setInterval(newSentence("Turning plastic into quinoa", 800);
// setInterval(newSentence("Saving the planet", 800);
