# GFP App - Gestione Consumi

Applicazione Rails 8 per la gestione e il monitoraggio dei consumi energetici (elettricità, acqua, gas).

## 📋 Requisiti di Sistema

- **Ruby**: 3.4.7 o superiore
- **Rails**: 8.1.0
- **Node.js**: versione LTS (per la gestione degli asset)
- **SQLite3**: 2.1 o superiore

## 🚀 Bootstrap dell'Applicazione

### 1. Clonare il Repository

```bash
git clone git@github.com:bifo90/gfp-app-selezione.git
cd gfp-app-selezione
```

### 2. Installare le Dipendenze

```bash
# Installa le gemme Ruby
bundle install
```

### 3. Configurare il Database

```bash
# Crea il database
rails db:create

# Esegui le migrazioni
rails db:migrate

# (Opzionale) Carica i dati di esempio
rails db:seed
```

### 4. Configurare le Credenziali

Genera le credenziali Rails se non esistono:

```bash
EDITOR="code --wait" rails credentials:edit
```

### 5. Avviare il Server

Avviare l'applicazione in due tab separati, questo perchè permette l'utilizzo di 'binding.irb' per debug

```bash
# TAB Terminale 1 - Modalità sviluppo
rails server

# TAB Terminale 2 -  usa il comando bin/dev per avviare con tutti i processi
bin/dev
```

L'applicazione sarà disponibile su `http://localhost:3000`

## 🧪 Esecuzione dei Test

### Eseguire Tutti i Test

```bash
rails test
```

### Eseguire Test Specifici

```bash
# Test dei modelli
rails test test/models

# Test dei controller
rails test test/controllers

# Test di integrazione
rails test test/integration

# Test specifico di un file
rails test test/models/consumption_test.rb

# Test specifico per nome
rails test test/models/consumption_test.rb:10
```

### Verifica della Copertura

```bash
# Esegui i test con report di copertura (se configurato)
COVERAGE=true rails test
```

## 📱 Guida alla Navigazione

### Homepage Pubblica

- **URL**: `/`
- **Descrizione**: Pagina di benvenuto pubblica
- **Accesso**: Nessuna autenticazione richiesta

### Autenticazione

#### Registrazione

- **URL**: `/sign_up/new`
- **Descrizione**: Crea un nuovo account utente
- **Campi richiesti**:
  - Nome
  - Cognome
  - Email
  - Password
  - Conferma password

#### Login

- **URL**: `/session/new`
- **Descrizione**: Accedi con le tue credenziali
- **Campi**: Email e Password

#### Reset Password

- **URL**: `/passwords/new`
- **Descrizione**: Recupera la password tramite email
- **Processo**:
  1. Inserisci la tua email
  2. Ricevi il link per il reset via email (funzione non attiva in quanto non c'è collegato alcun server SMTP, quindi copiare il link che vedi nel terminale generato con il parametro in rotta contenente il token di ripristino password)
  3. Crea una nuova password

### Area Admin (Richiede Autenticazione)

#### Dashboard

- **URL**: `/admin`
- **Descrizione**: Panoramica generale con statistiche degli ultimi 30 giorni
- **Contenuto**:
  - Riepilogo consumi per tipologia (elettricità, acqua, gas)
  - Statistiche dettagliate per ogni tipo di consumo
  - Medie e totali

#### Gestione Consumi

- **URL**: `/admin/consumptions`
- **Descrizione**: Lista completa di tutti i consumi registrati
- **Funzionalità**:
  - Visualizza tutti i consumi
  - Filtra per tipo (elettricità, acqua, gas)
  - Filtra per data (da/a)
  - Ordina per data o valore
  - Paginazione dei risultati

#### Nuovo Consumo

- **URL**: `/admin/consumptions/new`
- **Descrizione**: Registra un nuovo consumo
- **Campi richiesti**:
  - Tipo di consumo (elettricità, acqua, gas)
  - Valore numerico (≥ 0)
  - Data di registrazione

#### Modifica Consumo

- **URL**: `/admin/consumptions/:id/edit`
- **Descrizione**: Modifica un consumo esistente
- **Funzionalità**: Aggiorna valore e data

#### Elimina Consumo

- **Azione**: Click su "Elimina" nella lista consumi
- **Descrizione**: Rimuove definitivamente un consumo
- **Conferma**: Richiesta conferma prima dell'eliminazione

## 🎨 Funzionalità Principali

### Tipi di Consumo Supportati

1. **Elettricità** (⚡)

   - Unità di misura: kW
   - Icona: Fulmine

2. **Acqua** (💧)

   - Unità di misura: L.
   - Icona: Goccia

3. **Gas** (🔥)
   - Unità di misura: m³
   - Icona: Fiamma

### Analytics e Statistiche

L'applicazione fornisce:

- Calcolo medie giornaliere per utente e tipo
- Trend mensili (confronto mese corrente vs mese precedente)
- Top consumatori
- Consumi per giorno della settimana
- Picco di consumo giornaliero
- Stima dei costi
- Riepilogo utente completo
- Breakdown giornaliero

## 🛠️ Comandi Utili

```bash
# Console Rails
rails console

# Generare un nuovo migration
rails generate migration NomeMigration

# Rollback dell'ultima migrazione
rails db:rollback

# Pulire il database
rails db:reset

# Visualizzare le route
rails routes

# Controllare lo stile del codice
bundle exec rubocop

# Correggere automaticamente problemi di stile
bundle exec rubocop -A
```

## 📦 Tecnologie Utilizzate

- **Framework**: Ruby on Rails 8.1.0
- **Database**: SQLite3
- **Frontend**: TailwindCSS
- **Autenticazione**: has_secure_password (Rails 8)
- **Testing**: Minitest
- **Asset Pipeline**: Propshaft
- **Server**: Puma

## 🔒 Sicurezza

- Password criptate con BCrypt
- Token di reset password con scadenza (15 minuti)
- Protezione CSRF
- Rate limiting su endpoint sensibili
- Validazioni lato server

## 📝 Note di Sviluppo

- L'applicazione utilizza Rails 8 con le nuove funzionalità di autenticazione
- I consumi sono associati agli utenti e vengono eliminati in cascata
- Le misure vengono impostate automaticamente in base al tipo di consumo
- L'interfaccia è completamente in italiano

## 👥 Autori

Stefano Bifolco

## 📞 Supporto

Per problemi o domande, aprire una issue su GitHub.
