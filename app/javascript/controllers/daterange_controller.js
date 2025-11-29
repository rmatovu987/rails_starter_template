import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="daterange"
export default class extends Controller {
  connect() {
    new DateRangePicker('daterangepicker',
        {
          timePicker: false,
          // opens: 'left',
          drops: 'down',
          ranges: {
            'Today': [moment(), moment()],
            'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
            'Last 7 Days': [moment().subtract(6, 'days'), moment()],
            'Last 30 Days': [moment().subtract(29, 'days'), moment()],
            'This Month': [moment().startOf('month'), moment().endOf('month')],
            'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
            'This Year': [moment().startOf('year'), moment().endOf('year')],
            'Last Year': [moment().subtract(1, 'year').startOf('year'), moment().subtract(1, 'year').endOf('year')],
            'All Time': [moment('2000-01-01').startOf('day'), moment()]
          },
          locale: {
            format: "YYYY-MM-DD",
          }
        },
        function (start, end) {
          const form = this.element
          form.value = start.format('YYYY-MM-DD') + ' - ' + end.format('YYYY-MM-DD')
        })
  }
}