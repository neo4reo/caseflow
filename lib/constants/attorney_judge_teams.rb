module Constants::AttorneyJudgeTeams
  # rubocop:disable Metrics/LineLength
  JUDGES = [
    { "Dorilyn Ames" => ["Tabatha Blake Carter", "Rochelle Brunot", "Jerry Fowler", "Ryan Frank", "Jason Lyons", "Bryan Riordan", "Anne Rocktashel", "Nadia Stevens"],
      "Angel Caracciolo" => ["Laura Crawford", "Gregory Deemer", "Rahil Gandhi", "Tracy Joseph", "Meghan Moore", "Jonathan Trickey", "Willie Victoria Walker", "Gina Wilkerson"],
      "Kristin Haddock" => ["Irvin Cannaday", "Susan Krunic", "Sonja Mishalanie", "Christopher O'Donnell", "Arooj Sami", "Anne Shawkey", "Mariah Sim", "Dawn Ware"],
      "Mike Lyon" => ["Philip Franke", "Michael Harris", "Matthew Miller", "Christopher Murray", "Patricia Olson", "Shana Siesser", "Yuka Taylor"],
      "Anthony Mainelli" => ["Heather Harter", "Chad Howell", "Victoria Narducci", "Michael O'Connor", "Chinyere Orie", "Nasir Rasool", "Janelle Reid", "Tiakyta Willie"],
      "Gayle Strommen" => ["James Acosta-Davis", "Hallie Brokowsky", "Christine Grossman", "Kanisha Laffitte", "Zachary Sahraie", "Matthew Schlickenmaier", "Amber Smith", "Katherine Spragins"],
      "Yvette White" => ["Dalia Abdelbary", "Angela Barner", "Tiffany Berry", "Cynthia Cho", "Agnes Lech", "Gunella Lilly", "Tanner Ryan", "Maryam Zhuravitsky"],
      "Dave Wight" => ["Ronald Blake", "Erin Miller", "James Nelson", "Michael Nye", "Shanthala Raj", "Paul Rubin", "Melissa Timbers", "Robert Watkins"],
      "Jessica Zissimos" => ["Damon Chilcote", "R. Brouck Kuczynski", "Kristyn Osegueda", "Meredith Postek", "Brianne Rideout", "Jesmin Saikh", "Khiedrae Walker", "Merry Wulff"],
      "Paula DiLorenzo" => ["Josh Rutkin", "Luke McCabe", "Nadia Sangster", "Megan Purdum", "Michael Stedman", "Buck Denton", "LaTonja Sinckler", "Sean Mussey", "Capresha Edwards"],
      "Susan Kennedy" => ["Jackie Connolly", "Cynthia Wasser", "Sarah Richmond", "Saira Spicknall", "Marcella Coyne", "Joshua Costello", "Robert Batten", "Nikita Floore", "Gerline Johnson"],
      "Nathaniel Doan" => ["Ashley Dean", "Diane Boushehri", "Athena Hemphill", "Sarone Solomon", "Monica Dermarkar", "Kellye Thompson", "Yonelle Moore Lee", "Amanda Gibson", "Courtney Kass"],
      "Derek Brown" => ["Melissa Carsten", "Harold Beach", "Mary Rude", "Joseph Montanye", "Paul Bametzreider", "Tyquili Booker", "Allen Kerpan"],
      "Harvey Roberts" => ["John Hutcheson", "Spencer Layton", "Todd Gillett", "Dan Zhu", "Lorelle Driever", "Ki'ara Cross", "Hajrah Ahmad", "Thaddeus Cox", "Gillian Flynn"],
      "Matthew Tenner" => ["Shamil Patel", "Jessica Smith", "Yvette Hawkins", "Erin Anderson", "Mark Macek", "Braden Whitelaw", "Natasha Pendleton", "Vanessa-Nola Pratt", "Adrian Jackson"],
      "Jennifer Hwa" => ["Jasmine Negron", "Cassie Ford", "Kimberly Parke", "Jasmine Freeman", "Catherine Cykowski", "Lauren Bush", "Christopher Casey"],
      "Lesley Rein" => ["Alexis Parrish", "Journet Shaw", "Melissa Barbee", "Jill Coogan", "Alexandra Dellarco", "Shera Finn", "Carolyn Ryan", "Elise Ko"],
      "Milo Hawley" => ["Margaret Riley", "Terrence  Griffin", "Gillian  Slovick", "Brandon Williams", "Whitney Ripplinger", "Byron Moore", "Jonathan  Morris", "Shawn Ferguson", "Angela  Norwood"],
      "Andy Mackenzie" => ["Maureen Young", "Lori Barstow", "Anna-Lisa Evans", "Jonathan  Abrams", "Christopher Collins", "Brian Quarles", "Cameron Mukherjee", "Christopher Banks"],
      "George Senyk" => ["James Siegel", "Debbie Breitbeil", "Deborah Schechner", "William Skowronski", "Jason Dupont", "James Bayles", "Nichole Staskowski", "Porschia Poindexter"],
      "Victoria Moshiashwili" => ["Morgan Yuan", "Tereze Matta", "Matthew Showalter", "Nell Robinson", "Mary D'Allaird", "Sarah Lambert"],
      "Caryn Graham" => ["Christopher Lawson", "Kshama Hughes", "Saramae Kreitlow", "Alex Barone", "Tiffany  Wishard", "Bryan Herdliska", "Thomas Fales", "Cynthia Anderson"],
      "Mary Ellen Larkin" => ["Jason Davitian", "Robert Burriesci", "Rachel Erdheim", "Jack Komperda", "Caitlin Biggins", "Eric  Struening", "Michael Perkins", "Patrick  McLeod"],
      "Mary Sorisio" => ["Lori Wells-Green", "Bonnie Yoon", "Laura Yantz", "Katharine Marenna", "Lindsay Stallings", "Saurabh Patel", "Nicholas Breitbach", "Robert Dean"],
      "Estela Velez" => ["Karissa Wallin", "Julie Meawad", "Katherine Foster", "Jacqueline Sandler", "Renee Harris", "Alyssa Arnold", "Aaron Roe"],
      "Reynolds" => ["Sean Pflugner", "Nancy Snyder", "Alex Hampton", "Gordon Fraser", "Alejandro Diaz-Ferguson", "Lisa Nelson", "Ben Winburn", "Carlos Martinez"],
      "Powell" => ["Ashley Budd", "Anthony Flamini", "Jasmine Henriquez", "Mikel Espinoza", "John H. Baker", "Brian Lemoine"],
      "Martin" => ["Jennifer Deane", "Michelle Katz", "Timothy Anthony", "Jessica O'Connell", "Alexandra Solomon", "Samantha  Mountford", "Saudiee Brown", "Jeffery Higgins"],
      "Jeng" => ["Amanda Alderman", "Miyoung In", "Dan Schechter", "Grace Raftery", "Neferteria Brown", "Leanne Innet", "Stephen Freeman", "Jobe Kamal"],
      "Mullins" => ["Sara Schinnerer", "Patricia Veresink", "Amber Nolley", "Alex Kutrolli", "Youme McDonald", "Hannah Fisher", "Nakiya Whitaker", "Renee Trotter", "Timothy King"],
      "Howell" => ["Emily Redman", "Kristina Schaefer", "Kate Kovarovic", "Mirham Yocoub", "Alex Spigelman", "Tanga Bernal", "Brendan Evans"],
      "Banfield" => ["Julia  Anderson", "Daniela Van Wambeke", "William  Yates", "Carly Banister", "Sara Medina", "Rachel Mamis", "Mary Birder"],
      "Nathan Kroes" => ["Carrie Boyd Iwanowski", "Dave Havelka", "Russell Veldenz", "Ellen Brandau", "McKayle Bruce", "Adrian Odya-Weis", "Michael Gonzalez", "Robert Scarduzio"],
      "Vito Clementi" => ["Shazia Anwar", "Boris Cohen", "Carolyn Colley", "GraigJackson", "Jacqueline Miller", "Nykeia Miller", "Joshua Wozniak"],
      "Michelle Kane" => ["Rachel Costello", "Lindsay Durham (Mollan)", "Mathew Galante", "Kerry Hubers", "Robin Janofsky", "Morgan Lavan", "James (David)Leamon", "Amelia Parsons"],
      "Jonathan Kramer" => ["Lloyd Cramp", "Erika Duthely", "Jim Gallagher", "Andy Mack", "Johnny Ragheb", "Sean Raymond", "Michael Schnibben", "Tricia Sherrard"],
      "Simone Belcher-Mays" => ["Romina Casadei", "Bradley Farrell", "Tristin Harper", "Jane Lee", "Lorryn Logan", "Jane Nichols", "Megan Thomas", "Achiya Yaffe"],
      "Kalpanna Parakkal" => ["Freda Carmack", "Patrick Johnson", "Tom Kelly", "Christine Kung", "Kirsten Kunz", "Stephanie Owen", "Renee Williams", "Marla Woodarek"],
      "Jeff Parker" => ["Amanda Bedford", "Eric Blowers", "Eva Choi", "Carla Ferguson", "Patrick Meehan", "Shanna Moore", "Ashleigh Tenney"],
      "Holly Seesel" => ["Alan Boal", "Amanda Christensen", "Ryan Connally", "Tom Jones", "Edward Jones", "Naree Nelson", "Charles Teague"],
      "Alexandra Simpson" => ["Dominic Cheng", "Anel Hodzic", "Rahat Husain", "Chad Johnson", "Alyssa Keninger", "Earlene Rosenberg Morgan", "Jazamine Stallings", "Lynne Yasui"],
      "Anne Jaeger" => ["Brennae Brooks", "Michelle Celli", "Kiara Clark", "Jonathan Estes", "Lynn Htun", "Alexander Panio", "Kate Sosna", "Koria Stanton"],
      "Dana Benjamin-Johnson" => ["Daniel Barrett", "Michael Mazzucchelli", "Michael Sobiecki", "Mary Tang", "Anthony Vieux", "Kanha Vuong", "Timothy Campbell", "Erin Mortimer"],
      "John Crowley" => ["Tatiana Azizi-Barcelo", "Barry Gabay", "Richard Kettler", "Michael Marcum", "April Snoparsky", "Sadia Sorathia", "Neil Werner", "Victor Woehlke"],
      "Michael Skaltsounis" => ["Daniel Bassett", "Brian Cannon", "Scott Dale", "Anwar Daniels", "Pamela Daugherty", "Jose Carlos Garcia", "Michael Rescan", "Scott Shoreman"],
      "Ryan Kessel" => ["Corey Bosely", "Phyllis Childers", "Jason George", "Brandon Isaacs", "David Jimerfield", "Dominic Jones", "Armando Santiago", "Melanie Taylor"],
      "Simone Krembs" => ["Ian Altendorfer", "Matilda Bilstein", "Aileen Fagan", "Nathaniel Pettine", "Jennifer Smith-Jennings", "Laura Stepanick", "Philip Timmerman"],
      "Sonnet Bush" => ["Ruby Asante", "Jennifer Ivey-Crickenberger", "Elana Lederman", "Sarah Mahoney", "Jarrette Marley", "Nicole Northcutt", "Katherine Quander-Forde"],
      "Steve Reiss" => ["Joshua Castillo", "Kenneth Ciardiello", "Jacquelynn Jordan", "John Kitlas", "Scott Regan", "Cheryl Samuelson", "Tracie Wesner", "Michele-Ann Wilson", "Krzysztof Wysokinski"],
      "Blackwelder" => ["Tim Berryman", "Claire Davidoski", "Steve Eckerman", "Michelle Franklin", "Rashida Sims", "Nikki Yeh"],
      "Copeland" => ["Jasmine Crawford", "Jake Dworkin", "David Seaton", "Hal Smith, H", "Steve Wainaina"],
      "Fleming" => ["Monika Clark", "Georgio Comninos", "Lindsey Connor", "Tenisha Jiggetts", "David Katz", "Michael Neal", "Melanie Thompson"],
      "Heneks" => ["Debra Bredehorst", "Dan Brook", "Nadia Kamal", "Liz Kunju", "Chris Lamb", "PaRa Noh", "Alicia Wimbish"],
      "Herman" => ["Mohammad Alhinnawi", "Jennifer Burroughs", "Tom Douglas", "Teresa Grzeczkowicz", "Doug Humphrey", "Miranda Lee", "Motrya Mac", "Elizabeth Rekowski", "Paul Saindon"],
      "Ishizawar" => ["Janet Alexander", "Denise Casula", "Kate Churchwell", "Kathleen Fletcher", "Joe Gervasio", "Steve Johnston", "Paul Metzner", "Narili Shah", "Rakhee Vemulapplli"],
      "Kordich" => ["Tanya Adams", "Sonja An", "Alicia Cryan", "Denise Houle", "John Kim", "Thomas Moore", "Mike Sopko", "Tess Winkler", "Fatima Yankey"],
      "Millikan" => ["Cherrelle Bruton", "Steve Ginski", "Carole Kammel", "Dave Nelson", "Pauline Nguyen", "Cheri Smith, C", "Hannah Yoo"],
      "O'Shay" => ["Sheena Becker", "Jeana Bryant", "Jenny Cheng", "Jennifer Flynn", "Saif Kalolwala", "Carolyn Krasinski", "Kimberly Mitchell", "Neely Peden"] }
  ].freeze
  # rubocop:enable Metrics/LineLength
end
