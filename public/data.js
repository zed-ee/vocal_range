app_data = {
    languages: [ 
        { code: 'ee', 'index': 1 },
        { code: 'gb', 'index': 2 },
    ],        
    assets: {
      low: {
        image: "assets/tim_storms.png",
        sound: "assets/tim_storms.mp3",
      },
      high: {
        image: "assets/georgia_brown.png",
        sound: "assets/georgia_brown.mp3",
      }
    },
    messages: {
        et: {
            app: {
              restart:'Algusesse',
              next_lang:'ENG'
            },
            index: {
              button:'Alusta',
              h1: 'Testi oma<br>hääleulatust',
              h2: 'Milline on sinu kõrgeim ja <br> madalaim helisagedus ja noot?',
            },
            intro: {
              button:'Edasi',
              low: 'Esmalt kuuled <br>maailma madalaimat <br><u>inimese</u> häälsagedust',
              high: 'Nüüd kuuled <br>maailma kõrgeimat <br><u>inimese</u> häälsagedust',
            },
            play: {
              low: 'Maailma madalaim hääl<br>Tim Storms, Ameerika Ühendriigid<br>Madalaim sagedus: 0,189 Hz<br>Noot: G<sub>-7</sub><br>',
              high: 'Maailma kõrgeim hääl<br>Georgia Brown, Brasiilia<br>Kõrgeim sagedus: 25 087,7 Hz<br>Noot: G10',
            },
            intro2: {
              button:'Edasi',
              low: 'Nüüd proovi, <br>milline on sinu hääle<br><u>madalaim</u> helisagedus',
              high: 'Nüüd proovi, <br>milline on sinu hääle<br><u>kõrgeim</u> helisagedus',
            },
            record: {
              attempt1:"1. Katse",
              attempt2:"2. Katse",
              attempt3:"3. Katse"
            },
            results: {
              results: "Tulemused:",
              lowest_voice: "Maailma madalaim hääl:",
              lowest_note: "0,189 Hz / G<sub>-7</sub><br>",
              highest_voice: "Maailma kõrgeim hääl:",
              hightest_note: "25087 Hz / G10",
              your_lowest:"Sinu madalaim hääl:" ,
              your_highest: "Sinu kõrgeim hääl:",
              restart:"Alusta uuesti",
              send: "Saada e-postile"
            }
        }, 'en': {
            app: {
              restart:'Restart',
              next_lang:'EST'
            },
            index: {
              button:'Start',
              h1: 'Find your<br>vocal range',
              h2: 'How low or <br> how high can you go?',
            },
            intro: {
              button:'Next',
              low: 'First, you are going <br> to hear the world\'s deepest <br>voice made by a man',
              high: 'Now listen to <br> the world\'s highest voice',
            },
            play: {
              low: 'The world\'s lowest voice<br>Tim Storms, United States od America<br>Lowest frequency: 0,189 Hz<br>Note: G<sub>­7</sub><br>',
              high: 'The world\'s highest voice<br>Georgia Brown, Brazil<br>Highest frequency: 25 087,7 Hz<br>Note: G10',
            },
            intro2: {
              button:'Edasi',
              low: 'Next, find out <br> the <u>lowest</u> frequency<br>of your voice',
              high: 'Next, find out <br>the <u>highest</u> frequency<br>of your voice'
            },
            record: {
              attempt1:"1st Attempt",
              attempt2:"2nd Attempt",
              attempt3:"3rd Attempt"
            },            
            results: {
              results: "Results:",
              lowest_voice: "World's lowest vocal note:",
              lowest_note: "0,189 Hz / G<sub>-7</sub><br>",
              highest_voice: "World's highest vocal note:",
              hightest_note: "25087 Hz / G10",
              your_lowest:"Your lowest note:" ,
              your_highest: "Your highest note:",
              restart:"Back to start",
              email: "Send to e­mail"
            }
            
        }
	}
}
    