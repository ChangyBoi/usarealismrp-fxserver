const characterSelectionApp = new Vue({
  el: "#app",
  created() {
    window.addEventListener('keydown', (e) => {
      if (e.key == "ArrowLeft") {
        this.selectLeft()
      } else if (e.key == "ArrowRight") {
        this.selectRight()
      }
    });
  },
  data: {
		page: "list",
		characters: [],
		notification: {
			msg: "You don't appear to have any characters! Create one!",
			show: false
		},
    selectedCharacter: null,
    selectedCharIndex: null,
    selectedSpawn: null
  },
  methods: {
    createCharacter: function() {
      /* Get data from input form fields */
      var first_name = $('#first_name').val();
      var middle_name = $('#middle_name').val();
      var last_name = $('#last_name').val();
      var dob = $("#date_of_birth").val();

      /* Get date object for validation */
      var dobAsDate = new Date(dob);
      day = dobAsDate.getDate();
      month = dobAsDate.getMonth() + 1;
      year = dobAsDate.getFullYear();

      if (first_name.length > 2 && last_name.length > 2 && (year > 1900 || year < 2020 || !isNaN(day) || !isNaN(month) || !isNaN(year))) {
        var newCharData = {
          name: {
            first: first_name,
            middle: middle_name,
            last: last_name
          },
          dateOfBirth: dob
        }
        $.post('http://character-selection/new-character-submit', JSON.stringify(newCharData));
        /* Go back to list of chars */
        this.page = "list";
        this.notification.show = false;
      } else {
        this.notification.show = true;
        this.notification.msg = "Uh-oh! You didn't supply enough information! Please try again.";
      }
    },
    deleteCharacter: function() {
      if (this.selectedCharacter != null) {
        const modal = document.getElementById('confirm');
				const deleteName = document.getElementById('confirm_name');
        const deleteChar = document.getElementById('confirm_delete');
        const cancelChar = document.getElementById('confirm_cancel');

				modal.show();

				var char = this.selectedCharacter;
				deleteName.innerText = char.name.first + " " + char.name.last;

      } else {
        console.log("No selected character");
      }
    },
    confirmDelete: function() {
      const modal = document.getElementById('confirm');
      var char = this.selectedCharacter;
      $.post('http://character-selection/delete-character', JSON.stringify({
        id: char.id,
        rev: char.rev,
        createdTime: char.created.time
      }));
      modal.close();
      this.selectedCharacter = null;
    },
    cancelDelete: function() {
      const modal = document.getElementById('confirm');
      modal.close();
    },
    disconnect: function() {
      $.post('http://character-selection/disconnect', JSON.stringify({}));
    },
    selectCharacter: function(charIndex) {
      this.selectedCharIndex = charIndex;
      this.selectedCharacter = this.characters[charIndex];
      var selectedChar = this.selectedCharacter;
      $('.character').each(function () {
        var char = $(this);
        if (char.attr("data-id") == selectedChar.id) {
          char[0].scrollIntoView(false)
        }
      });
    },
    selectSpawn: function(spawn) {
      this.selectedSpawn = spawn;
      /* Highlight border */
      $('.spawn-point').each(function () {
        if ($(this).attr("data-id") == spawn) {
          $(this).css("border-color", "#308bcd");
        } else {
          $(this).css("border", "2px solid #ddd");
        }
      });
    },
    spawnCharacter: function() {
      if (!this.selectedCharacter || !this.selectedSpawn)
        return;
      $.post('http://character-selection/select-character', JSON.stringify({
        id: this.selectedCharacter.id,
        name: this.selectedCharacter.name,
        spawn: this.selectedSpawn
      }));
      this.page = "list"
    },
    selectRight: function() {
      if (this.page == "list") {
        this.selectedCharIndex += 1
        if (this.selectedCharIndex >= this.characters.length)
          this.selectedCharIndex = 0
        this.selectCharacter(this.selectedCharIndex)
      }
    },
    selectLeft: function() {
      if (this.page == "list") {
        this.selectedCharIndex -= 1
        if (this.selectedCharIndex < 0)
          this.selectedCharIndex = this.characters.length - 1
        this.selectCharacter(this.selectedCharIndex)
      }
    }
  },
  computed: {
		showNotification: function() {
      if (this.characters) {
        if (this.characters.length == 0) {
  				return true;
  			} else {
  				return this.notification.show;
  			}
      }
		}
  },
  filters: {
    displayMoney: function(value) {
      return value.formatMoney(2, '.', ',');
    }
  }
})

document.onreadystatechange = () => {
  if (document.readyState === "complete") {
    /* Listen for events from lua script */
    window.addEventListener('message', function(event) {
      var eventType = event.data.type;
        if (eventType == "toggleMenu") {
          if (event.data.open == true){
            characterSelectionApp.characters = event.data.characters;
            if (event.data.characters.length > 0) {
              characterSelectionApp.selectedCharacter = event.data.characters[0]
              characterSelectionApp.selectedCharIndex = 0
            }
            document.body.style.display = "flex";
          }
          else
            document.body.style.display = "none";
        } else if (eventType == "displayGUI") {
          document.body.style.display = event.data.open = "flex";
          $(".characters").scrollLeft(0)
        }
    });
  };
};

function confirmDelete() {
  characterSelectionApp.confirmDelete();
}

function cancelDelete() {
  characterSelectionApp.cancelDelete();
}

Number.prototype.formatMoney = function (c, d, t) {
	var n = this,
		c = isNaN(c = Math.abs(c)) ? 2 : c,
		d = d == undefined ? "." : d,
		t = t == undefined ? "," : t,
		s = n < 0 ? "-" : "",
		i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
		j = (j = i.length) > 3 ? j % 3 : 0;
	return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};
