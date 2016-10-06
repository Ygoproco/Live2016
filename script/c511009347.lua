--Parasite Generator
function c511009347.initial_effect(c)
	
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c511009347.condition)
	e1:SetTarget(c511009347.acttarget)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7570,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	-- e2:SetCondition(c511009347.condition)
	e2:SetTarget(c511009347.target)
	e2:SetOperation(c511009347.operation)
	c:RegisterEffect(e2)
	
	--counted as 2 for parasite Queen
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(511009347)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,511002961))
	c:RegisterEffect(e3)
	
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c511009347.indestg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	
	
	if not c511009347.global_check then
		c511009347.global_check=true
		c511009347[0]=false
		c511009347[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c511009347.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c511009347.clear)
		Duel.RegisterEffect(ge3,0)
	end
end
function c511009347.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c511009347.dfilter,1,nil,tp) then
		c511009347[tp]=true
	end
	if eg:IsExists(c511009347.dfilter,1,nil,1-tp) then
		c511009347[1-tp]=true
	end
end
function c511009347.dfilter(c,e,tp)
	return c:IsSetCard(0x410) 
end
function c511009347.clear(e,tp,eg,ep,ev,re,r,rp)
	c511009347[0]=false
	c511009347[1]=false
end

function c511009347.acttarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c511009347.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	if c511009347.target(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c511009347.operation)
		c511009347.target(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end

function c511009347.condition(e,tp,eg,ep,ev,re,r,rp)
	return c511009347[tp] or c511009347[1-tp]
end
function c511009347.filter(c,e,tp)
	return c:IsCode(511002961) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511009347.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c511009347.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c511009347.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFlagEffect(tp,511009347)==0
		end
		Duel.RegisterFlagEffect(tp,511009347,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c511009347.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c511009347.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetOperation(c511009347.retop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		tc:RegisterEffect(e2,true)
		
		Duel.BreakEffect()
		
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	
		local tg=Duel.GetMatchingGroup(c511009347.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	
		if ft<=0 or tg:GetCount()==0 or (ft>1 and tg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=tg:Select(tp,ft,ft,nil)
		-- if g:GetCount()>0 then
			-- Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		-- end
		local tc=g:GetFirst()
			while tc do
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e2:SetRange(LOCATION_MZONE)
					e2:SetCode(EVENT_PHASE+PHASE_END)
					e2:SetOperation(c511009347.retop)
					e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
					e2:SetCountLimit(1)
					tc:RegisterEffect(e2,true)
					tc=g:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
end
function c511009347.retop(e,tp,eg,ep,ev,re,r,rp)
Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c511009347.indestg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x410)
end
