#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

using namespace std;

class Date {
public:
    Date(int year, int month, int day) : year_(year), month_(month), day_(day) {
        if (!is_valid(year_, month_, day_)) {
            throw invalid_argument("Invalid date.");
        }
    }

    int year() const { return year_; }
    int month() const { return month_; }
    int day() const { return day_; }

    friend ostream& operator<<(ostream& os, const Date& date) {
        os << date.year_ << '-'
           << (date.month_ < 10 ? "0" : "") << date.month_ << '-'
           << (date.day_ < 10 ? "0" : "") << date.day_;
        return os;
    }

private:
    int year_;
    int month_;
    int day_;

    static bool is_leap_year(int year) {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    }

    static bool is_valid(int year, int month, int day) {
        if (year <= 0 || month < 1 || month > 12 || day < 1) {
            return false;
        }

        const int days_in_month[] = {
            31, 28, 31, 30, 31, 30,
            31, 31, 30, 31, 30, 31
        };

        int max_day = days_in_month[month - 1];
        if (month == 2 && is_leap_year(year)) {
            max_day = 29;
        }

        return day <= max_day;
    }
};

class Book {
public:
    enum class Genre {
        fiction,
        nonfiction,
        periodical,
        biography,
        children
    };

    Book(const string& isbn, const string& title, const string& author,
         const Date& copyright_date, Genre genre)
        : isbn_(isbn),
          title_(title),
          author_(author),
          copyright_date_(copyright_date),
          genre_(genre),
          checked_out_(false) {
        if (!is_valid_isbn(isbn_)) {
            throw invalid_argument("Invalid ISBN format.");
        }
        if (title_.empty() || author_.empty()) {
            throw invalid_argument("Title and author cannot be empty.");
        }
    }

    string isbn() const { return isbn_; }
    string title() const { return title_; }
    string author() const { return author_; }
    Date copyright_date() const { return copyright_date_; }
    Genre genre() const { return genre_; }
    bool is_checked_out() const { return checked_out_; }

    void check_out() {
        if (checked_out_) {
            throw logic_error("Book is already checked out.");
        }
        checked_out_ = true;
    }

    void check_in() {
        if (!checked_out_) {
            throw logic_error("Book is already in the library.");
        }
        checked_out_ = false;
    }

    static bool is_valid_isbn(const string& isbn) {
        int first = -1;
        int second = -1;
        int third = -1;

        for (size_t i = 0; i < isbn.size(); ++i) {
            if (isbn[i] == '-') {
                if (first == -1) {
                    first = static_cast<int>(i);
                } else if (second == -1) {
                    second = static_cast<int>(i);
                } else if (third == -1) {
                    third = static_cast<int>(i);
                } else {
                    return false;
                }
            }
        }

        if (first <= 0 || second <= first + 1 || third <= second + 1 ||
            third >= static_cast<int>(isbn.size()) - 1) {
            return false;
        }

        if (!all_digits(isbn.substr(0, first)) ||
            !all_digits(isbn.substr(first + 1, second - first - 1)) ||
            !all_digits(isbn.substr(second + 1, third - second - 1))) {
            return false;
        }

        string last_part = isbn.substr(third + 1);
        return last_part.size() == 1 && is_alnum_char(last_part[0]);
    }

    friend bool operator==(const Book& lhs, const Book& rhs) {
        return lhs.isbn_ == rhs.isbn_;
    }

    friend bool operator!=(const Book& lhs, const Book& rhs) {
        return !(lhs == rhs);
    }

    friend ostream& operator<<(ostream& os, const Book& book) {
        os << "Title: " << book.title_ << '\n'
           << "Author: " << book.author_ << '\n'
           << "ISBN: " << book.isbn_;
        return os;
    }

private:
    string isbn_;
    string title_;
    string author_;
    Date copyright_date_;
    Genre genre_;
    bool checked_out_;

    static bool all_digits(const string& text) {
        if (text.empty()) {
            return false;
        }
        for (char ch : text) {
            if (ch < '0' || ch > '9') {
                return false;
            }
        }
        return true;
    }

    static bool is_alnum_char(char ch) {
        return (ch >= '0' && ch <= '9') ||
               (ch >= 'a' && ch <= 'z') ||
               (ch >= 'A' && ch <= 'Z');
    }
};

class Patron {
public:
    Patron(const string& user_name, const string& card_number, double fee = 0.0)
        : user_name_(user_name), card_number_(card_number), fee_(fee) {
        if (user_name_.empty() || card_number_.empty()) {
            throw invalid_argument("Patron name and card number cannot be empty.");
        }
    }

    string user_name() const { return user_name_; }
    string card_number() const { return card_number_; }
    double fee() const { return fee_; }

    void set_fee(double fee) { fee_ = fee; }
    bool owes_fee() const { return fee_ > 0.0; }

private:
    string user_name_;
    string card_number_;
    double fee_;
};

class Library {
public:
    struct Transaction {
        Book book;
        Patron patron;
        Date date;

        Transaction(const Book& book, const Patron& patron, const Date& date)
            : book(book), patron(patron), date(date) {}
    };

    void add_book(const Book& book) {
        if (has_book(book.isbn())) {
            throw logic_error("Book already exists in library.");
        }
        books_.push_back(book);
    }

    void add_patron(const Patron& patron) {
        if (has_patron(patron.card_number())) {
            throw logic_error("Patron already exists in library.");
        }
        patrons_.push_back(patron);
    }

    void check_out_book(const string& isbn, const string& card_number, const Date& date) {
        Book& book = find_book(isbn);
        Patron& patron = find_patron(card_number);

        if (patron.owes_fee()) {
            throw logic_error("Patron owes library fees.");
        }
        if (book.is_checked_out()) {
            throw logic_error("Book is already checked out.");
        }

        book.check_out();
        transactions_.push_back(Transaction(book, patron, date));
    }

    vector<string> patrons_with_fees() const {
        vector<string> names;
        for (const Patron& patron : patrons_) {
            if (patron.owes_fee()) {
                names.push_back(patron.user_name());
            }
        }
        return names;
    }

    const vector<Book>& books() const { return books_; }
    const vector<Patron>& patrons() const { return patrons_; }
    const vector<Transaction>& transactions() const { return transactions_; }

private:
    vector<Book> books_;
    vector<Patron> patrons_;
    vector<Transaction> transactions_;

    bool has_book(const string& isbn) const {
        for (const Book& book : books_) {
            if (book.isbn() == isbn) {
                return true;
            }
        }
        return false;
    }

    bool has_patron(const string& card_number) const {
        for (const Patron& patron : patrons_) {
            if (patron.card_number() == card_number) {
                return true;
            }
        }
        return false;
    }

    Book& find_book(const string& isbn) {
        for (Book& book : books_) {
            if (book.isbn() == isbn) {
                return book;
            }
        }
        throw logic_error("Book record not found in library.");
    }

    Patron& find_patron(const string& card_number) {
        for (Patron& patron : patrons_) {
            if (patron.card_number() == card_number) {
                return patron;
            }
        }
        throw logic_error("Patron record not found in library.");
    }
};

static string genre_to_string(Book::Genre genre) {
    switch (genre) {
        case Book::Genre::fiction:
            return "fiction";
        case Book::Genre::nonfiction:
            return "nonfiction";
        case Book::Genre::periodical:
            return "periodical";
        case Book::Genre::biography:
            return "biography";
        case Book::Genre::children:
            return "children";
        default:
            return "unknown";
    }
}

int main() {
    try {
        Book book1("978-7-121-0-A", "The C++ Programming Language", "Bjarne Stroustrup",
                   Date(2013, 5, 19), Book::Genre::nonfiction);
        Book book2("978-7-302-1-5", "Journey to the West", "Wu Cheng'en",
                   Date(2000, 1, 1), Book::Genre::fiction);
        Book book3("978-7-115-2-X", "Children's Stories", "Anonymous",
                   Date(2018, 6, 1), Book::Genre::children);

        cout << "Book information:" << '\n';
        cout << book1 << "\n\n";

        cout << "book1 == book2 ? " << (book1 == book2 ? "true" : "false") << '\n';
        cout << "book1 != book2 ? " << (book1 != book2 ? "true" : "false") << '\n';
        cout << "book3 genre: " << genre_to_string(book3.genre()) << "\n\n";

        Patron patron1("Alice", "P1001");
        Patron patron2("Bob", "P1002", 25.0);

        Library library;
        library.add_book(book1);
        library.add_book(book2);
        library.add_book(book3);
        library.add_patron(patron1);
        library.add_patron(patron2);

        library.check_out_book("978-7-121-0-A", "P1001", Date(2026, 5, 25));
        cout << "Alice borrowed book successfully." << "\n\n";

        vector<string> debtors = library.patrons_with_fees();
        cout << "Patrons with fees:" << '\n';
        for (const string& name : debtors) {
            cout << name << '\n';
        }
        cout << '\n';

        cout << "Transaction records:" << '\n';
        for (const Library::Transaction& transaction : library.transactions()) {
            cout << transaction.patron.user_name() << " borrowed "
                 << transaction.book.title() << " on "
                 << transaction.date << '\n';
        }
    } catch (const exception& e) {
        cerr << "Error: " << e.what() << '\n';
        return 1;
    }

    return 0;
}
