from google.cloud import firestore


def increment_visitor_count(request):
	db = firestore.Client()
	collection_ref = db.collection('visitors')
	
	if not collection_ref.get():
		doc_ref = collection_ref.document('count')
		count = 1

	else:
		doc_ref = collection_ref.document('count')
		count_snapshot = doc_ref.get()
		count = count_snapshot.get('count') + 1

	new_count = {'count': count}
	doc_ref.set(new_count)
	return dict(new_count)
