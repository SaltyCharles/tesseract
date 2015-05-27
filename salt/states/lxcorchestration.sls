# File: /srv/salt/lxcorchestration.sls

{% set lxcs = ['lxc1', 'lxc2','lxc3'] %}

{% for lxc in lxcs %}
minion_setup_{{ lxc }}:
  salt.function:
    - tgt: 'roles:iis'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - salt-run cloud.profile prof=salty-lxc instances={{ lxc }}
 {% endfor %}