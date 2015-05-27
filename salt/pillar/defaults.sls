# /srv/pillar/defaults.sls

{% if grains['os'] == 'RedHat' %}
apache: httpd
git: git
{% elif grains['os'] == 'Debian' %}
apache: apache2
git: git-core
{% endif %}

build_server: {{ grains['machine_id'] }}
builder: SaltyCharles