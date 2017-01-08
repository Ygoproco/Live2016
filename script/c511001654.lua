--Battle Tuning
function c511001654.initial_effect(c)
	--synchro effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001654.sctg)
	e1:SetOperation(c511001654.scop)
	c:RegisterEffect(e1)
	if not c511001654.global_check then
		c511001654.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c511001654.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511001654.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE then
		local tc=eg:GetFirst()
		while tc do
			tc:RegisterFlagEffect(511001654,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
			tc=eg:GetNext()
		end
	end
end
function c511001654.spfilter(c,tp)
	return Duel.IsExistingMatchingCard(c511001654.filter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c511001654.filter(c,sync)
	return c:GetFlagEffect(511001654)>0 and c:IsType(TYPE_TUNER) and sync:IsSynchroSummonable(c)
end
function c511001654.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511001654.spfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c511001654.scop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	local g=Duel.GetMatchingGroup(c511001654.spfilter,tp,LOCATION_EXTRA,0,nil,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=Duel.SelectMatchingCard(tp,c511001654.filter,tp,LOCATION_MZONE,0,1,1,nil,sg:GetFirst())
		Duel.HintSelection(tg)
		Duel.SynchroSummon(tp,sg:GetFirst(),tg:GetFirst())
	end
end
