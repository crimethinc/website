;(function (){
  // hand rolled version of $(document).ready
  // If the DOM is loaded by the time this script is run, then call callback immedately
  if (document.readyState !== 'loading'){
    domReadyCallback();
  } else {
    // Otherwise attach a listener for for DOM loaded and call, callback then.
    document.addEventListener('DOMContentLoaded', domReadyCallback);
  }

  function domReadyCallback() {
    // Maps 'amount_slider' _values_ to Stripe dollar _amounts_ ('quantity')
    var mapping = {
      "1":     1, "2":     2, "3":     3, "4":     4, "5":      5, "6":     6, "7":     7, "8":     8, "9":     9, "10":   10,
      "11":   11, "12":   12, "13":   13, "14":   14, "15":    15, "16":   16, "17":   17, "18":   18, "19":   19, "20":   20,
      "21":   21, "22":   22, "23":   23, "24":   24, "25":    25, "26":   30, "27":   35, "28":   40, "29":   45, "30":   50,
      "31":   55, "32":   60, "33":   65, "34":   70, "35":    75, "36":   80, "37":   85, "38":   90, "39":   95, "40":  100,
      "41":  105, "42":  110, "43":  115, "44":  120, "45":   125, "46":  130, "47":  135, "48":  140, "49":  145, "50":  150,
      "51":  200, "52":  250, "53":  300, "54":  350, "55":   400, "56":  450, "57":  500, "58":  550, "59":  600, "60":  650,
      "61":  700, "62":  750, "63":  800, "64":  850, "65":   900, "66":  950, "67": 1000, "68": 1500, "69": 2000, "70": 2500,
      "71": 3000, "72": 3500, "73": 4000, "74": 4500, "75":  5000, "76": 5500, "77": 6000, "78": 6500, "79": 7000, "80": 7500,
      "81": 8000, "82": 8500, "83": 9000, "84": 9500, "85": 10000
    };
    var stripeFormEl = document.querySelector('#js_stripe_form');
    var sliderEl = stripeFormEl.querySelector('#amount_slider');
    var updateButtonEl = stripeFormEl.querySelector('.js-button-update');

    // Setting the correct slider value on page load requires some funky stuff,
    // mainly this line right here that I copy/pasted straight from stackoverflow:
    //
    // Object.keys(array).find(key => array[key] === value)
    //
    // That will return a key with a given value, which we need because all we have
    // is the current subscription amount/quantity coming from the Stripe API. As you
    // can see from the 'mapping' hash above, it goes value => amount, which works great
    // down there in the 'amount_slider' event listener, but we need the inverse here:

    var startingValueForSlider = Object.keys(mapping).find(key => mapping[key] === Number.parseInt(sliderEl.dataset.startingAmount))

    sliderEl.setAttribute('value', startingValueForSlider);

    sliderEl.addEventListener('input', function(e) {
       // updates 'amount' value using the mapping above
       stripeFormEl.querySelector('#amount').setAttribute("value", mapping[this.value]);

      if(!updateButtonEl) return; // bail because not on edit.html.erb

      // enables 'update' button only if current value is different the starting value
      if (this.value === startingValueForSlider) {
        updateButtonEl.setAttribute("disabled", "");
      } else {
        updateButtonEl.removeAttribute("disabled");
      }
    });

  }
})();
