# Configure the TorqueBox Servlet-based session store.
# Provides for server-based, in-memory, cluster-compatible sessions
EnterpriseSearch::Application.config.session_store :cookie_store, :key => '_enterprise-search_session'
