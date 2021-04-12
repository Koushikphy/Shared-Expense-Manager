void calculateShares() {
  print("1234");
}

var categories = ["Bills", "Food", "Misc"];

var users = ["Koushik", "Satyam", "Joy"];

var expenseStats = {
  "Total Spends": [12, 30, 44], // in order of user list
  "Total Owe": [11, 50, 74],
  "Net Owe": [10, 55, 99]
};

List expenses = [
  {
    "date": "01-03-2021",
    "person": "Satyam",
    "item": "Groceries",
    "category": "Food",
    "amount": "290",
    "shareBy": "All"
  },
  {
    "date": "01-03-2021",
    "person": "Joy",
    "item": "Milk",
    "category": "Food",
    "amount": "220",
    "shareBy": "Koushik"
  },
  {
    "date": "02-03-2021",
    "person": "Joy",
    "item": "Misc",
    "category": "Food",
    "amount": "200",
    "shareBy": "Satyam"
  },
  {
    "date": "02-03-2021",
    "person": "Koushik",
    "item": "Rent",
    "category": "Bills",
    "amount": "64",
    "shareBy": "All"
  },
  {
    "date": "02-03-2021",
    "person": "Koushik",
    "item": "Gas",
    "category": "Food",
    "amount": "64",
    "shareBy": "All"
  },
  {
    "date": "02-03-2021",
    "person": "Koushik",
    "item": "Water",
    "category": "Food",
    "amount": "64",
    "shareBy": "All"
  },
  {
    "date": "02-03-2021",
    "person": "Koushik",
    "item": "Vegetables",
    "category": "Food",
    "amount": "64",
    "shareBy": "All"
  },
  {
    "date": "02-03-2021",
    "person": "Koushik",
    "item": "Misc",
    "category": "Food",
    "amount": "64",
    "shareBy": "All"
  },
];
