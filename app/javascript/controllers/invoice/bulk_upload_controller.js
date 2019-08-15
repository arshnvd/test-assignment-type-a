import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ['file', 'fileName', 'fileSize', 'uploadStatus'];
  connect() {
    this.fileTarget.addEventListener('change', (event) => {
      let selected = !!this.fileTarget.value;
      this.toggleMoreOptions(selected);
      selected && this.selected(event.currentTarget.files[0])
    });

    this.fileTarget.addEventListener('direct-upload:start', ()=> {
      this.uploadStatusTarget.innerHTML = `<i class="fas fa-circle-notch fa-spin mr-2"></i>`;
    });

    this.fileTarget.addEventListener('direct-upload:end', ()=> {
      this.uploadStatusTarget.innerHTML = `<i class="fas fa-check text-success mr-2"></i>`;
      this.fileTarget.setAttribute('disabled', false);
    })
  }

  toggleMoreOptions(show) {
    let moreOptions = this.element.querySelectorAll('.more-options');

    for (let option of moreOptions) {
      show ? option.classList.remove('d-none') : option.classList.add('d-none')
    }
  }

  cancel(event) {
    Rails.stopEverything(event);

    this.fileTarget.value = null;
    let _event_           = new CustomEvent('change');

    this.fileTarget.dispatchEvent(_event_);
  }

  selected(file) {
    this.fileNameTarget.innerHTML = `<i class="fas fa-file-csv"></i> ${file.name}`;
    this.fileSizeTarget.innerText = (file.size / 1024).toFixed(2) + 'KB';
  }
}