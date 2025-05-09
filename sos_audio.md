# BLOC01

Super ! Voici un **exemple complet de pipeline local** : **reconnaissance vocale (audio → texte) + LLM local (texte → réponse) + synthèse vocale (texte → audio)**.
Ce système est **100 % local**, sans envoi de données vers Internet.

---

## 🧠 Ce que fait ce système :

1. **Vous parlez** dans votre micro.
2. **Whisper local** convertit votre voix en texte.
3. **LLM local (GPT4All ou Ollama)** génère une réponse.
4. **pyttsx3** lit la réponse à voix haute.

---

## 🛠️ **Prérequis**

### 📦 Installez ces outils :

#### 1. Whisper (local, léger avec `tiny` ou `base`)

```bash
pip install openai-whisper
pip install torch  # ou 'pip install torch torchvision torchaudio' selon votre config
```

#### 2. Microphone + reconnaissance audio

```bash
pip install sounddevice numpy
```

#### 3. Synthèse vocale

```bash
pip install pyttsx3
```

#### 4. LLM local (exemple avec GPT4All ou Ollama) :

* **[GPT4All](https://gpt4all.io/index.html)** (GUI ou API locale)
* **[Ollama](https://ollama.com/)** : installez un LLM local comme Mistral ou LLaMA2 :

```bash
ollama run mistral
```

---

## 🧾 **Code Python local : audio → texte → réponse → voix**

```python
import whisper
import sounddevice as sd
import numpy as np
import pyttsx3
import subprocess

# Initialiser synthèse vocale
engine = pyttsx3.init()
engine.setProperty("rate", 150)

# Charger le modèle Whisper
model = whisper.load_model("base")  # ou "tiny" pour plus de vitesse

# Enregistrement audio
def record_audio(duration=5, samplerate=16000):
    print("🎙️ Parlez maintenant...")
    audio = sd.rec(int(duration * samplerate), samplerate=samplerate, channels=1, dtype='float32')
    sd.wait()
    print("🔇 Enregistrement terminé.")
    return np.squeeze(audio)

# Sauvegarde en WAV
def save_audio(audio, filename="recording.wav", samplerate=16000):
    import soundfile as sf
    sf.write(filename, audio, samplerate)
    return filename

# Transcrire avec Whisper
def transcribe_audio(file_path):
    result = model.transcribe(file_path, language='fr')
    return result["text"]

# Obtenir une réponse d’un LLM local (Ollama ici)
def ask_ollama(prompt):
    result = subprocess.run(
        ["ollama", "run", "mistral"],
        input=prompt.encode(),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    response = result.stdout.decode().split("\n")[-1].strip()
    return response

# Lire un texte à voix haute
def speak(text):
    engine.say(text)
    engine.runAndWait()

# === PIPELINE PRINCIPAL ===
if __name__ == "__main__":
    audio_data = record_audio()
    file_path = save_audio(audio_data)
    
    texte = transcribe_audio(file_path)
    print("📝 Texte reconnu :", texte)

    if texte.strip():
        reponse = ask_ollama(texte)
        print("🤖 Réponse :", reponse)
        speak(reponse)
    else:
        print("Aucune voix détectée.")
```

---

## ✅ **Résultat :**

* Entièrement **hors ligne**.
* Aucun envoi de données.
* Vous pouvez personnaliser les questions, voix, ou changer le LLM (`gpt4all`, `llama3`, etc.).

---

Souhaitez-vous une version avec une interface graphique, une interaction continue, ou l'intégration d'un autre modèle ?

# BLOC02

Oui, absolument ! Le système peut très bien accepter **des fichiers audio existants** au lieu d'enregistrer avec le micro en temps réel.

---

### ✅ **Comment faire lire un fichier audio existant avec Whisper**

Vous pouvez **remplacer l'enregistrement** par un simple chargement de fichier `.wav`, `.mp3`, etc. Voici comment adapter le code :

---

### 🧾 **Extrait de code pour utiliser un fichier audio existant**

Remplacez cette partie du code :

```python
audio_data = record_audio()
file_path = save_audio(audio_data)
```

par :

```python
file_path = "mon_audio.mp3"  # ou .wav, .m4a, etc.
```

Puis continuez avec :

```python
texte = transcribe_audio(file_path)
```

---

### 🎯 Exemple complet (audio existant)

```python
import whisper
import pyttsx3
import subprocess

# Initialiser synthèse vocale
engine = pyttsx3.init()
engine.setProperty("rate", 150)

# Charger Whisper
model = whisper.load_model("base")

# Transcrire fichier audio
def transcribe_audio(file_path):
    result = model.transcribe(file_path, language="fr")
    return result["text"]

# Demander à un LLM local via Ollama
def ask_ollama(prompt):
    result = subprocess.run(
        ["ollama", "run", "mistral"],
        input=prompt.encode(),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    return result.stdout.decode().strip().split("\n")[-1]

# Lecture vocale
def speak(text):
    engine.say(text)
    engine.runAndWait()

# === Fichier existant à transcrire ===
file_path = "mon_audio.mp3"  # Remplacez par votre fichier

texte = transcribe_audio(file_path)
print("📝 Transcription :", texte)

if texte.strip():
    reponse = ask_ollama(texte)
    print("🤖 Réponse :", reponse)
    speak(reponse)
else:
    print("Aucune transcription trouvée.")
```

---

### 📌 À noter :

* Whisper gère très bien : `.mp3`, `.wav`, `.m4a`, etc.
* Pas besoin de convertir le fichier à la main, Whisper s’en charge.
* Vous pouvez automatiser le traitement de plusieurs fichiers si besoin.

---

# BLOC03

Parfait ! Voici comment créer une **interface simple avec glisser-déposer** pour :

* déposer un fichier audio (`.mp3`, `.wav`, etc.),
* le **transcrire avec Whisper**,
* envoyer le texte au **LLM local** (ex. : **Ollama**),
* et lire la réponse à voix haute avec `pyttsx3`.

---

## 🎯 Objectif :

Interface avec bouton ou glisser-déposer pour lancer un traitement complet **audio → texte → réponse → voix**.

---

## 🧰 Prérequis Python :

Installez les bibliothèques nécessaires :

```bash
pip install whisper pyttsx3 tkinter
pip install torch  # si ce n’est pas encore fait
```

---

## 🧾 Code complet d'une interface glisser-déposer

```python
import whisper
import pyttsx3
import tkinter as tk
from tkinter import filedialog, messagebox
import subprocess
import os

# Initialiser Whisper et pyttsx3
model = whisper.load_model("base")
engine = pyttsx3.init()
engine.setProperty('rate', 150)

# Traitement du fichier audio
def traiter_audio(file_path):
    try:
        transcription = model.transcribe(file_path, language='fr')["text"]
        print("Transcription :", transcription)
        afficher_resultat("📝 Transcription :", transcription)

        if transcription.strip():
            response = ask_ollama(transcription)
            print("Réponse LLM :", response)
            afficher_resultat("🤖 Réponse :", response)
            speak(response)
        else:
            afficher_resultat("⚠️ Aucune transcription détectée.")
    except Exception as e:
        afficher_resultat(f"Erreur : {e}")

# Interroger Ollama (modèle local)
def ask_ollama(prompt):
    result = subprocess.run(
        ["ollama", "run", "mistral"],
        input=prompt.encode(),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    return result.stdout.decode().strip().split("\n")[-1]

# Lecture vocale
def speak(text):
    engine.say(text)
    engine.runAndWait()

# Afficher dans l’interface
def afficher_resultat(titre, texte=""):
    result_text.config(state=tk.NORMAL)
    result_text.insert(tk.END, f"{titre}\n{texte}\n\n")
    result_text.config(state=tk.DISABLED)

# Gestion du bouton
def choisir_fichier():
    file_path = filedialog.askopenfilename(
        filetypes=[("Fichiers audio", "*.mp3 *.wav *.m4a")]
    )
    if file_path:
        afficher_resultat(f"📥 Fichier sélectionné : {file_path}")
        traiter_audio(file_path)

# === Interface Tkinter ===
fenetre = tk.Tk()
fenetre.title("Assistant vocal local")
fenetre.geometry("600x400")

label = tk.Label(fenetre, text="🎤 Glissez un fichier audio ici ou cliquez sur le bouton :")
label.pack(pady=10)

btn = tk.Button(fenetre, text="Choisir un fichier audio", command=choisir_fichier)
btn.pack(pady=5)

result_text = tk.Text(fenetre, height=15, state=tk.DISABLED, wrap=tk.WORD)
result_text.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)

fenetre.mainloop()
```

---

## ✅ Fonctionnalités :

* Interface simple en **Tkinter**.
* Lecture des fichiers audio (`.mp3`, `.wav`, etc.).
* Transcription locale (Whisper).
* Dialogue avec un LLM local (Ollama).
* Synthèse vocale locale (pyttsx3).
* Aucun besoin de connexion Internet.

---

### 🔁 À améliorer :

* Glisser-déposer direct (avec `DnD` ou `TkinterDnD2`, optionnel).
* Suivi visuel du traitement.
* Intégration de plusieurs modèles ou voix.

Souhaitez-vous que je vous montre comment activer **le vrai glisser-déposer par glissement** (drag & drop visuel) ?

# BLOC04 Watchfolder

Oui, tout à fait ! Utiliser un **watchfolder (dossier surveillé)** est une excellente approche pour automatiser un traitement audio → texte → LLM → voix **dès qu’un fichier est ajouté dans un dossier**.

---

## 🔄 Fonctionnement :

1. Un script **surveille un dossier** (ex. `./audios`).
2. Dès qu’un **fichier audio** (mp3, wav, etc.) est ajouté :

   * Il est transcrit avec **Whisper**.
   * Le texte est envoyé au **LLM local (Ollama, GPT4All, etc.)**.
   * La réponse est **lue à voix haute** (avec `pyttsx3`).

---

## 🧰 Pré-requis :

```bash
pip install watchdog whisper pyttsx3
```

---

## 🧾 Code complet d’un système avec **watchfolder**

```python
import time
import os
import whisper
import pyttsx3
import subprocess
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# Paramètres
WATCH_FOLDER = "./audios"
SUPPORTED_EXTENSIONS = (".mp3", ".wav", ".m4a")

# Initialisation
model = whisper.load_model("base")
engine = pyttsx3.init()
engine.setProperty("rate", 150)

# Traitement du fichier audio
def traiter_fichier_audio(file_path):
    print(f"🎧 Nouveau fichier détecté : {file_path}")
    try:
        transcription = model.transcribe(file_path, language="fr")["text"]
        print("📝 Transcription :", transcription)

        if transcription.strip():
            reponse = ask_ollama(transcription)
            print("🤖 Réponse :", reponse)
            lire_texte(reponse)
        else:
            print("⚠️ Aucun texte détecté.")
    except Exception as e:
        print("❌ Erreur :", e)

# Appel LLM local (Ollama ici)
def ask_ollama(prompt):
    result = subprocess.run(
        ["ollama", "run", "mistral"],
        input=prompt.encode(),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    return result.stdout.decode().strip().split("\n")[-1]

# Synthèse vocale
def lire_texte(text):
    engine.say(text)
    engine.runAndWait()

# Handler du dossier
class AudioHandler(FileSystemEventHandler):
    def on_created(self, event):
        if not event.is_directory and event.src_path.lower().endswith(SUPPORTED_EXTENSIONS):
            time.sleep(1)  # Attendre que le fichier soit complètement écrit
            traiter_fichier_audio(event.src_path)

# Lancer l’observateur
if __name__ == "__main__":
    print(f"👀 Surveillance du dossier : {WATCH_FOLDER}")
    os.makedirs(WATCH_FOLDER, exist_ok=True)

    event_handler = AudioHandler()
    observer = Observer()
    observer.schedule(event_handler, WATCH_FOLDER, recursive=False)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
        print("🛑 Surveillance arrêtée.")

    observer.join()
```

---

## ✅ Ce que fait ce script :

* Surveille le dossier `./audios`.
* Traite automatiquement tout nouveau fichier audio.
* Fonctionne **entièrement hors ligne**.
* S’adapte à tous les fichiers : `.mp3`, `.wav`, `.m4a`.

---

### 🧩 Extensions possibles :

* Sauvegarder la transcription + réponse dans un `.txt`.
* Supprimer ou archiver les fichiers traités.
* Ajouter une interface de logs ou historique.

Souhaitez-vous que je vous montre une version qui enregistre les transcriptions et réponses dans des fichiers `.txt` automatiquement ?


Souhaitez-vous que je vous montre comment traiter **plusieurs fichiers audio en boucle** ou créer une **interface glisser-déposer** ?
