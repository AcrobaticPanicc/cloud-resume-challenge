fetch('https://my-proxy-kcory2ywjq-uc.a.run.app/increment_visitor_count')
    .then(response => {
        if (!response.ok) {
            throw new Error('Could not fetch visitor count');
        }
        return response.json();
    })
    .then(data => {
        document.getElementById('counter').textContent = data.count;
    })
    .catch(error => {
        console.log('Could not fetch visitor count:', error.message);
        document.getElementById('counter').textContent = 'Failed to load counter.';
    });
