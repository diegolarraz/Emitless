export const addActiveClassToCategory = () => {
  const categoryButtons = document.querySelectorAll(".category");
  const input = document.getElementById('query');

  input.addEventListener('keyup', (event) => {
    if (input.value !== "") {
      categoryButtons.forEach((listElement) => {
      listElement.classList.remove('category-active');
    });
    }
  });

  categoryButtons.forEach((button) => {
    button.addEventListener('click', (event) => {
      categoryButtons.forEach((listElement) => {
        listElement.classList.remove('category-active');
      });
      button.classList.add('category-active');
    });
  });
};
