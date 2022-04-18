from telegram.ext import Updater, CommandHandler, MessageHandler, Filters
import queue

# Bot username: https://t.me/BNODNA_bot
class BNODNABot:
    def __init__(self, messageList, analyzer, poster):
        self.messageList = messageList
        self.analyzer = analyzer
        self.poster = poster
        updater = Updater("5122241411:AAGh8GhaJyQlJijL6NhQSJP08U4D-G5O40M", use_context=True)

        dp = updater.dispatcher   
        dp.add_handler(CommandHandler("start", self.start))
        dp.add_handler(CommandHandler("help", self.help))
        dp.add_handler(MessageHandler(Filters.text, self.textRecieved))
        dp.add_error_handler(self.error)

        # Start the Bot
        updater.start_polling()

        #updater.idle()

    def start(self, update, context):
        update.message.reply_text('Welcome to the BNODNA bot. Text me anything.')

    def help(self, update, context):
        update.message.reply_text('Just text me anything, I\'ll answer with sentiment analysis of your text and take it into account when making music.')

    def textRecieved(self, update, context):
        analysis = self.analyzer.polarity_scores(update.message.text)
        update.message.reply_text("Positivity: " + str(analysis['pos']) +"\nNeutrality: + " + str(analysis['neu']) + \
            "\nNegativity: "+ str(analysis['neg']) + "\nCombined score: " + str(analysis['compound']))
        self.messageList.put(("/BNOOSC/TelegramMsg/", [analysis['neg'],\
            analysis['neu'], analysis['pos'], analysis['compound'], update.message.text]))
        
        self.poster.addToQueue(update.message.text, 0)


    def error(self, update, context):
        print('Update %s \n', update)
        print('caused error %s\n', context.error)
    