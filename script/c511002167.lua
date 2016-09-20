--闇晦ましの城
function c511002167.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c511002167.operation)
	c:RegisterEffect(e1)
end
function c511002167.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(511002167)==0 then
			tc:RegisterFlagEffect(511002167,RESET_PHASE+PHASE_END,0,1)
			--no tribute
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(10000080,1))
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LIMIT_SET_PROC)
			e1:SetCondition(c511002167.ntcon)
			e1:SetOperation(c511002167.ntop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			--1 tribute
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(10000080,1))
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_LIMIT_SET_PROC)
			e2:SetCondition(c511002167.tcon)
			e2:SetOperation(c511002167.top)
			e2:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			--2 tribute
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(10000080,1))
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_LIMIT_SET_PROC)
			e3:SetCondition(c511002167.ttcon)
			e3:SetOperation(c511002167.ttop)
			e3:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end		
end
function c511002167.spchk(c)
	return c:IsFaceup() and not c:IsStatus(STATUS_DISABLED) and c:GetOriginalCode()==511002167
end
function c511002167.ntcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and c:GetLevel()<=4
end
function c511002167.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.IsExistingMatchingCard(c511002167.spchk,tp,LOCATION_MZONE,0,1,nil) then
		e:SetTargetRange(POS_FACEDOWN,0)
	else
		e:SetTargetRange(POS_FACEDOWN_DEFENSE,0)
	end
end
function c511002167.tcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and (c:GetLevel()==5 or c:GetLevel()==6) 
		and Duel.GetTributeCount(c)>=1
end
function c511002167.top(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.IsExistingMatchingCard(c511002167.spchk,tp,LOCATION_MZONE,0,1,nil) then
		e:SetTargetRange(POS_FACEDOWN,0)
	else
		e:SetTargetRange(POS_FACEDOWN_DEFENSE,0)
	end
	local g=Duel.SelectTribute(tp,c,1,1)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c511002167.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-2 and Duel.GetTributeCount(c)>=2 
		and c:GetLevel()>=7
end
function c511002167.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.IsExistingMatchingCard(c511002167.spchk,tp,LOCATION_MZONE,0,1,nil) then
		e:SetTargetRange(POS_FACEDOWN,0)
	else
		e:SetTargetRange(POS_FACEDOWN_DEFENSE,0)
	end
	local g=Duel.SelectTribute(tp,c,2,2)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
