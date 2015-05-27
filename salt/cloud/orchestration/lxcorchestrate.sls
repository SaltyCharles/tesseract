# Master side orchestration

minion_setup:
  salt.function:
    - tgt: 'entsaltymaster'
    - name: cmd.run
    - arg:
      - salt-run cloud.profile prof=salty-lxc instances=lxc1,lxc2,lxc3