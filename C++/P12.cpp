#include <iostream.h>

class konto {
	private:
		char name[80];
		float kontostand;
		float fluktuation;
		int eroeffnet;
	public:
		konto(void);
		~konto(void);
		void eroeffnen(void);
		void einzahlen(void);
		void auszahlen(void);
		void abfragen(void);
};

konto::konto(void)
{
	cout << "Konstruktor wurde aufgerufen." <<endl;
	name[0] = '\0';
	kontostand = 0;
	eroeffnet = 0;
}


konto::~konto(void)
{
	cout << "Destruktor wurde aufgerufen." <<endl;
}

void konto::eroeffnen(void)
{
	char a;
	if (eroeffnet==0) {
		kontostand = -1;
		while (kontostand < 0) {
			cout << "Bitte Startkapital eingeben" <<endl;
			cin >> kontostand;
		}
		cout << "Wie heissen Sie ?";
		cin >> name;
		cout <<endl <<endl <<"Ihr Name ist " <<name <<" und ihr Startkapital betr�gt " <<kontostand <<endl;
		cout <<"Sind diese Angaben korrekt ?";
		switch (a) {
			case 'j' : eroeffnet=1;break;
			default : eroeffnet=0;break;
		}
	}
	else cout << "Sorry, aber das Konto ist bereits er�ffnet!";
}

void konto::einzahlen(void)
{
	fluktuation = -1;
	while (fluktuation < 0) {
		cout << "Wieviel Geld m�chten sie einbezahlen" <<endl;
		cin >> fluktuation;
	}
	kontostand += fluktuation;
}

void konto::auszahlen(void)
{
	fluktuation=-1;
	while (fluktuation < 0) {
		cout << "Wieviel Geld m�chten sie abheben" <<endl;
		cin >> fluktuation;
		if (kontostand - fluktuation<0) cout << "sorry, aber Sie haben nur noch Fr:" << kontostand;
		else kontostand -= fluktuation;
	}
}

void konto::abfragen(void)
{
	cout << name <<", dein Kontostand betr�gt CHF " << kontostand;
}




int main(void) 
{
	konto konten[10];
	char c = 'x';
	int b = -1;
	while (b != 10) {
		cout << "Bitte Konto ausw�hlen(0-9): ";
		cin >> b;
		cout << endl;
			while (c != 'q') {
				cout << endl << "Willkommen bei der Gr�mpelbank" << endl;
				cout << "------------------------------" << endl <<endl;
				cout << "Kontonummer ist " << b <<endl;
				cout << "Bitte dr�cken sie :" << endl << endl;
				cout << "k   f�r Konto er�ffnen" << endl;
				cout << "e   f�r Einzahlen" << endl;
				cout << "a   f�r Abheben" << endl;
				cout << "z   f�r Kontoauszug" << endl;
				cout << "q   f�r Ende" << endl << "Auswahl: ";
				cin >> c;
				if (c == 'k') konten[b].eroeffnen();
				if (c == 'e') konten[b].einzahlen();
				if (c == 'a') konten[b].auszahlen();
				if (c == 'z') konten[b].abfragen();		
			}
		c = 'x';
	}
	return 0;
}
