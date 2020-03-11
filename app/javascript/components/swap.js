export const swapCards = () => {
  const swapButtons = document.querySelectorAll(".swap-button");
  swapButtons.forEach((button) => {
    let outCard = document.getElementById('out')
    let inCard = document.getElementById('in')
    button.addEventListener('click', (event) => {
      event.preventDefault();
      outCard.classList.add('.move-out');
      inCard.classList.add('.move-in');
      setTimeout(function(){ window.location.href = "/basket"; }, 3400);
    });
  });

};
