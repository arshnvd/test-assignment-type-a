import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['errors', 'progress', 'info'];
  connect() {
    let uid = this.element.dataset.uid;
    App.notifications.listen(uid);

    document.addEventListener(`notifications.processed.${uid}`, (event) => {
      console.log();
      this.progressTarget.style.width = '100%';
      this.infoTarget.innerHTML = `<i class="fas fa-check text-success mr-1"></i> ${event.detail.report.processed} Record processed.`;
      this.displayErrors(event.detail.report.messages);
    });

    document.addEventListener(`notifications.progress.${uid}`, (event) => {
      this.progressTarget.style.width = `${event.detail.progress}%`;
    })
  }
  displayErrors(errors) {
    if (errors.length) {
      this.errorsTarget.innerHTML = '';
      for (let error of errors) {
        this.errorsTarget.innerHTML = this.errorsTarget.innerHTML + `<li class="text-danger">${error}</li>`;
      }
    }
  }
}