#include "perlmouth.h"

/* extern void connection_free (LmConnection *connection); */

extern LmHandlerResult perlmouth_lm_message_handler_new_cb(LmMessageHandler* handler, LmConnection* connection, LmMessage* message, gpointer user_data);

void
perlmouth_lm_connection_open_cb(LmConnection* connection, gboolean success, gpointer callback) {
	gperl_callback_invoke((GPerlCallback*)callback, NULL, connection, success);
}

void
perlmouth_lm_connection_authenticate_cb(LmConnection* connection, LmDisconnectReason reason, gpointer callback) {
	gperl_callback_invoke((GPerlCallback*)callback, NULL, connection, reason);
}

void
perlmouth_lm_connection_set_disconnect_function_cb(LmConnection* connection, LmDisconnectReason reason, gpointer callback) {
	gperl_callback_invoke((GPerlCallback*)callback, NULL, connection, reason);
}


/*
LmHandlerResult
perlmouth_lm_message_handler_new_cb(LmMessageHandler* handler, LmConnection* connection, LmMessage* message, gpointer callback) {
	GValue return_value = {0,};
	LmHandlerResult retval;
	g_value_init(&return_value, ((GPerlCallback*)callback)->return_type);
	gperl_callback_invoke((GPerlCallback*)callback, &return_value, handler, connection, message);
	retval = g_value_get_enum(&return_value);
	g_value_unset(&return_value);
	return retval;
}
*/

MODULE = Net::Jabber::Loudmouth::Connection		PACKAGE = Net::Jabber::Loudmouth::Connection	PREFIX = lm_connection_

LmConnection*
lm_connection_new(class, server)
		const gchar *server
	C_ARGS:
		server

LmConnection*
lm_connection_new_with_context(class, server, context)
		const gchar *server
		GMainContext *context
	C_ARGS:
		server, context

gboolean
lm_connection_open(connection, result_cb, user_data=NULL)
		LmConnection* connection
		SV *result_cb
		SV *user_data
	PREINIT:
		GError *error = NULL;
		GType param_types[2];
		GPerlCallback *callback;
	CODE:
		param_types[0] = PERLMOUTH_TYPE_CONNECTION;
		param_types[1] = G_TYPE_BOOLEAN;

		callback = gperl_callback_new(result_cb, user_data, 2, param_types, G_TYPE_NONE);
		RETVAL = lm_connection_open(connection, perlmouth_lm_connection_open_cb, callback, (GDestroyNotify)gperl_callback_destroy, &error);
		if (!RETVAL)
			gperl_croak_gerror(NULL, error);
	OUTPUT:
		RETVAL

gboolean
lm_connection_open_and_block(connection)
		LmConnection* connection
	PREINIT:
		GError* error = NULL;
	CODE:
		RETVAL = lm_connection_open_and_block(connection, &error);
		if (!RETVAL)
			gperl_croak_gerror(NULL, error);
	OUTPUT:
		RETVAL

void
lm_connection_cancel_open(connection)
		LmConnection* connection

gboolean
lm_connection_close(connection)
		LmConnection* connection
	PREINIT:
		GError* error = NULL;
	CODE:
		RETVAL = lm_connection_close(connection, &error);
		if (!RETVAL)
			gperl_croak_gerror(NULL, error);
	OUTPUT:
		RETVAL

gboolean
lm_connection_authenticate(connection, username, password, resource, auth_cb, user_data=NULL)
		LmConnection* connection
		const gchar* username
		const gchar* password
		const gchar* resource
		SV* auth_cb
		SV* user_data
	PREINIT:
		GError* error = NULL;
		GType param_types[2];
		GPerlCallback* callback;
	CODE:
		param_types[0] = PERLMOUTH_TYPE_CONNECTION;
		param_types[1] = G_TYPE_BOOLEAN;
		
		callback = gperl_callback_new(auth_cb, user_data, 2, param_types, G_TYPE_NONE);
		RETVAL = lm_connection_authenticate(connection, username, password, resource, (LmResultFunction)perlmouth_lm_connection_authenticate_cb, callback, (GDestroyNotify)gperl_callback_destroy, &error);
		if (!RETVAL)
			gperl_croak_gerror(NULL, error);
	OUTPUT:
		RETVAL

gboolean
lm_connection_authenticate_and_block(connection, username, password, resource)
		LmConnection* connection
		const gchar* username
		const gchar* password
		const gchar* resource
	PREINIT:
		GError* error = NULL;
	CODE:
		RETVAL = lm_connection_authenticate_and_block(connection, username, password, resource, &error);
		if (!RETVAL)
			gperl_croak_gerror(NULL, error);
	OUTPUT:
		RETVAL

void
lm_connection_set_keep_alive_rate(connection, rate)
		LmConnection* connection
		guint rate

gboolean
lm_connection_is_open(connection)
		LmConnection* connection

gboolean
lm_connection_is_authenticated(connection)
		LmConnection* connection

const gchar*
lm_connection_get_server(connection)
		LmConnection* connection

void
lm_connection_set_server(connection, server)
		LmConnection* connection
		const gchar* server

void
lm_connection_set_jid(connection, jid)
		LmConnection* connection
		const gchar* jid

const gchar*
lm_connection_get_jid(connection)
		LmConnection* connection

guint
lm_connection_get_port(connection)
		LmConnection* connection

void
lm_connection_set_port(connection, port)
		LmConnection* connection
		guint port

LmSSL*
lm_connection_get_ssl(connection)
		LmConnection* connection

void
lm_connection_set_ssl(connection, ssl)
		LmConnection* connection
		LmSSL_ornull* ssl

LmProxy*
lm_connection_get_proxy(connection)
		LmConnection* connection

void
lm_connection_set_proxy(connection, proxy)
		LmConnection* connection
		LmProxy_ornull* proxy

gboolean
lm_connection_send(connection, message)
		LmConnection* connection
		LmMessage* message
	PREINIT:
		GError* error = NULL;
	CODE:
		RETVAL = lm_connection_send(connection, message, &error);
		if (!RETVAL)
			gperl_croak_gerror(NULL, error);
	OUTPUT:
		RETVAL

gboolean
lm_connection_send_with_reply(connection, message, handler)
		LmConnection* connection
		LmMessage* message
		LmMessageHandler* handler
	PREINIT:
		GError* error = NULL;
	CODE:
		RETVAL = lm_connection_send_with_reply(connection, message, handler, &error);
		if (!RETVAL)
			gperl_croak_gerror(NULL, error);
	OUTPUT:
		RETVAL

LmMessage*
lm_connection_send_with_reply_and_block(connection, message)
		LmConnection* connection
		LmMessage* message
	PREINIT:
		GError* error = NULL;
	CODE:
		RETVAL = lm_connection_send_with_reply_and_block(connection, message, &error);
		if (!RETVAL)
			gperl_croak_gerror(NULL, error);
	OUTPUT:
		RETVAL

gboolean
lm_connection_send_raw(connection, str)
		LmConnection* connection
		const gchar* str
	PREINIT:
		GError* error = NULL;
	CODE:
		RETVAL = lm_connection_send_raw(connection, str, &error);
		if (!RETVAL)
			gperl_croak_gerror(NULL, error);
	OUTPUT:
		RETVAL

LmMessageHandler*
lm_connection_register_message_handler(connection, type, priority, handler_cb, user_data=NULL)
		LmConnection* connection
		LmMessageType type
		LmHandlerPriority priority
		SV* handler_cb
		SV* user_data
	PREINIT:
		GType param_types[3];
		GPerlCallback* callback;
	CODE:
		param_types[0] = PERLMOUTH_TYPE_MESSAGE_HANDLER;
		param_types[1] = PERLMOUTH_TYPE_CONNECTION;
		param_types[2] = PERLMOUTH_TYPE_MESSAGE;

		if (!handler_cb || !SvOK(handler_cb) || !SvROK(handler_cb)) {
			croak("handler_cb must be either a code reference or derived from Net::Jabber::Loudmouth::MessageHandler");
		} else if (sv_isobject(handler_cb) && sv_derived_from(handler_cb, "Net::Jabber::Loudmouth::MessageHandler")) {
			if (user_data != NULL)
				croak("You can't use user_data if you pass a Net::Jabber::Loudmouth::MessageHandler derived object as handler_cb");
			RETVAL = SvLmMessageHandler(handler_cb);
		} else if (SvTYPE(SvRV(handler_cb)) == SVt_PVCV) {
			callback = gperl_callback_new(handler_cb, user_data, 3, param_types, PERLMOUTH_TYPE_HANDLER_RESULT);
			RETVAL = lm_message_handler_new(perlmouth_lm_message_handler_new_cb, callback, (GDestroyNotify)gperl_callback_destroy);
		} else {
			croak("your handler_cb ist weird. This shouldn't happen. Please report a bug.");
		}
		lm_connection_register_message_handler(connection, RETVAL, type, priority);
	OUTPUT:
		RETVAL

void
lm_connection_unregister_message_handler(connection, type, handler)
		LmConnection* connection
		LmMessageType type
		LmMessageHandler* handler
	C_ARGS:
		connection, handler, type

void
lm_connection_set_disconnect_function(connection, disconnect_cb, user_data=NULL)
		LmConnection* connection
		SV* disconnect_cb
		SV* user_data
	PREINIT:
		GPerlCallback* callback;
		GType param_types[2];
	CODE:
		param_types[0] = PERLMOUTH_TYPE_CONNECTION;
		param_types[1] = PERLMOUTH_TYPE_DISCONNECT_REASON;

		callback = gperl_callback_new(disconnect_cb, user_data, 2, param_types, G_TYPE_NONE);
		lm_connection_set_disconnect_function(connection, perlmouth_lm_connection_set_disconnect_function_cb, callback, (GDestroyNotify)gperl_callback_destroy);

LmConnectionState
lm_connection_get_state(connection)
		LmConnection* connection
