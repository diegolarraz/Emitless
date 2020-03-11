export const activeClassOnNavbar = () => {
  const progressionNavbar = document.querySelectorAll('.nav-item');

  let currentPath = window.location.pathname;

  progressionNavbar.forEach((listElement) => {
    listElement.classList.remove('active')
  });

  switch (currentPath) {
    case '/items':
      progressionNavbar[0].classList.add('active');
      break;
    case '/compare':
      progressionNavbar[1].classList.add('active');
      break;
    case '/basket':
      progressionNavbar[2].classList.add('active');
      break;
  }
};
