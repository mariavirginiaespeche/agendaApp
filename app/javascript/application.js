// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


document.addEventListener('turbo:load', () => {
    const deleteLinks = document.querySelectorAll('a[data-method="delete"]');
    deleteLinks.forEach(link => {
      link.addEventListener('click', function(event) {
        const confirmed = confirm(this.dataset.confirm);
        if (!confirmed) {
          event.preventDefault();
        }
      });
    });
  });
  