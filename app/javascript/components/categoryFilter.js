export const addActiveClassToCategory = () => {
  const categoryButtons = document.querySelectorAll(".category");

  categoryButtons.forEach((button) => {
    button.addEventListener('click', (event) => {
      categoryButtons.forEach((listElement) => {
        listElement.classList.remove('category-active');
      });
      button.classList.add('category-active');
    });
  });
};
