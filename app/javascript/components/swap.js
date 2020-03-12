export const swapCards = () => {
  const swapButtons = document.querySelectorAll(".swap-button");
  let index = 0;
  swapButtons.forEach((button) => {
    let outCard = document.querySelectorAll('.pc-out')[index];
    let inCard = document.querySelectorAll('.pc-in')[index];
    button.addEventListener('click', (event) => {
      event.preventDefault();
      outCard.classList.add('move-out');
      inCard.classList.add('move-in');
      setTimeout(function(){ window.location.href = "/basket"; }, 3400);
      index += 1;
    });
  });

};
