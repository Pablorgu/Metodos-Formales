chan enter[2] = [0] of {bit};
chan release = [0] of {bit};

active [2] proctype proceso() {
    byte pnum = _pid;
    inicio:
    enter[pnum]?_;
    critical:
    printf("Proc %d in critical section\n", pnum);
    release!1;
    printf("Proc %d leaves critical section\n",pnum);
    goto inicio;
}

active proctype arbitro() {
    inicio:
    if
    ::enter[0]!1;
    cara: printf("Cara\n");
    ::enter[1]!1;
    cruz: printf("Cruz\n");
    fi
    release?1;
    goto inicio;
}

ltl uno_entra_en_sc_con_inf_freq { [] <> (proceso[0]@critical || proceso[1]@critical) }
ltl p2_justicia { ([] <> arbitro@cara && [] <> arbitro@cruz) -> [] <> (proceso[0]@critical || proceso[1]@critical) }
