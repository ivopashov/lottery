window.LotteryView = Backbone.View.extend({
  initialize: function(numbers) {
    this.chosenNumbers = this.$el.data('numbers');
    this.render();
  },

  lotteryNumbers: function() {
    let numbers = [];
    let temp = [];

    for (let index = 1; index <= 49; index++) {
      let numberRecord = {index: index};
      numberRecord.chosen = this.chosenNumbers.indexOf(index) != -1;

      temp.push(numberRecord);

      if (temp.length == 7) {
        numbers.push(temp);
        temp = [];
      }
    }

    return numbers;
  },

  events: {
    'click .lottery-number': 'selectOrDeseletNumber'
  },

  disallowSelect: function (number) {
    return this.chosenNumbers.length == 6 && this.chosenNumbers.indexOf(number) == -1;
  },

  selectOrDeseletNumber: function(event){
    let clickedLotteryNumber = parseInt($(event.currentTarget).html());

    if (this.disallowSelect(clickedLotteryNumber)) {
      return;
    }

    let index = this.chosenNumbers.indexOf(clickedLotteryNumber);

    if (index == -1) {
      this.chosenNumbers.push(clickedLotteryNumber);
    } else {
      this.chosenNumbers.splice(index, 1);
    }

    this.render();
  },

  getTemplate: function () {
    return `
      <table class="table table-striped">
        {{#each this}}
          <tr>
            {{#each this}}
              <td class="lottery-number{{#if chosen}} selected{{/if}}">{{index}}</td>
            {{/each}}
          </tr>
        {{/each}}
      </table>
    `;
  },

  render: function () {
    let template = Handlebars.compile(this.getTemplate());
    let html = template(this.lotteryNumbers());

    this.$el.find('input[type="submit"]').prop('disabled', this.chosenNumbers.length != 6);
    this.$el.find('.lottery-numbers').html(html);
    this.$el.find('.lottery-numbers-input').val(this.chosenNumbers.join());
  }
});