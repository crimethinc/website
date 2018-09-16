$(function() {
  // Maps 'amount_slider' _values_ to Stripe dollar _amounts_ ('quantity')
  var mapping = {
    "1":    1, "2":    2, "3":    3, "4":    4, "5":    5, "6":    6, "7":     7, "8":    8, "9":    9, "10":  10,
    "11":  11, "12":  12, "13":  13, "14":  14, "15":  15, "16":  16, "17":   17, "18":  18, "19":  19, "20":  20,
    "21":  21, "22":  22, "23":  23, "24":  24, "25":  25, "26":  30, "27":   35, "28":  40, "29":  45, "30":  50,
    "31":  55, "32":  60, "33":  65, "34":  70, "35":  75, "36":  80, "37":   85, "38":  90, "39":  95, "40": 100,
    "41": 105, "42": 110, "43": 115, "44": 120, "45": 125, "46": 130, "47":  135, "48": 140, "49": 145, "50": 150,
    "51": 200, "52": 250, "53": 300, "54": 350, "55": 400, "56": 450, "57":  500, "58": 550, "59": 600, "60": 650,
    "61": 700, "62": 750, "63": 800, "64": 850, "65": 900, "66": 950, "67": 1000
  }

  var slider = document.getElementById('amount_slider')

  // Setting the correct slider value on page load requires some funky stuff,
  // mainly this line right here that I copy/pasted straight from stackoverflow:
  //
  // Object.keys(array).find(key => array[key] === value)
  //
  // That will return a key with a given value, which we need because all we have
  // is the current subscription amount/quantity coming from the Stripe API. As you
  // can see from the 'mapping' hash above, it goes value => amount, which works great
  // down there in the 'amount_slider' event listener, but we need the inverse here:

  var startingValueForSlider = Object.keys(mapping).find(key => mapping[key] === Number.parseInt(slider.dataset.startingAmount))

  slider.value = startingValueForSlider

  document.getElementById('amount_slider').addEventListener('input', function(e) {
    // enables 'update' button only if current value is different the starting value
    if (this.value === startingValueForSlider) {
      $(".js-button-update").prop("disabled", true)
    } else {
      $(".js-button-update").prop("disabled", false)
    }

    // updates 'amount' value using the mapping above
    document.getElementById('amount').value = mapping[this.value];
  });
});
